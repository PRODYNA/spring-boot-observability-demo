package com.prodyna.person.api;

import com.prodyna.person.core.PersonEntity;
import com.prodyna.person.core.PersonMapper;
import com.prodyna.person.core.PersonRepository;
import com.prodyna.person.domain.Person;
import io.opentelemetry.api.common.AttributeKey;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.instrumentation.annotations.WithSpan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

import java.util.Objects;
import java.util.UUID;

@RestController
@RequestMapping("/")
public class PersonController {

    private static final Logger LOGGER = LoggerFactory.getLogger(PersonController.class);

    private final PersonRepository personRepository;

    private final PersonMapper personMapper;

    @Autowired
    public PersonController(PersonRepository personRepository, PersonMapper personMapper) {
        this.personRepository = personRepository;
        this.personMapper = personMapper;
    }

    @GetMapping("/{id}")
    public Person fetchPerson(@PathVariable UUID id) {
        return personRepository.findById(id).map(personMapper::toModel).orElseThrow(() -> new RuntimeException("Person not found"));
    }

    @PostMapping
    @WithSpan
    public Person createPerson(@RequestBody Person person) {
        LOGGER.info("Creating person: {}", person);
        PersonEntity entity = personMapper.toEntity(person);
        if (Objects.isNull(entity.getId())) {
            entity.setId(UUID.randomUUID());
        }
        Person model = personMapper.toModel(personRepository.save(entity));
        Span currentSpan = Span.current();
        currentSpan.addEvent("person.create", Attributes.of(AttributeKey.stringKey("person.id"), entity.getId().toString()));
        currentSpan.setAttribute("person.name", entity.getFirstName() + " " + entity.getLastName());
        return model;
    }

    @GetMapping
    public Page<Person> fetchAllPersons(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size) {
        LOGGER.info("Fetching all persons with page: {} and size: {}", page, size);
        Page<Person> output = personRepository.findAll(PageRequest.of(page, size)).map(personMapper::toModel);

        // in 20% of the cases, throw a runtime exception
        if (Math.random() < 0.2) {
            throw new RuntimeException("Random exception");
        }

        // in 20% of the cases, mark this span as error
        if (Math.random() < 0.2) {
            Span.current().recordException(new RuntimeException("Random exception"));
            return null;
        }

        // in 20% of the cases, sleep for 1 second
        if (Math.random() < 0.2) {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        return output;
    }
}
