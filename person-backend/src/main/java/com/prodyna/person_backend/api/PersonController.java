package com.prodyna.person_backend.api;

import com.prodyna.person_backend.core.PersonEntity;
import com.prodyna.person_backend.core.PersonMapper;
import com.prodyna.person_backend.core.PersonRepository;
import com.prodyna.person_backend.domain.Person;
import java.util.Objects;
import java.util.UUID;

import io.opentelemetry.api.common.AttributeKey;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.api.trace.Span;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/person")
public class PersonController {

  private final PersonRepository personRepository;

  private final PersonMapper personMapper;

  @Autowired
  public PersonController(PersonRepository personRepository, PersonMapper personMapper) {
    this.personRepository = personRepository;
    this.personMapper = personMapper;
  }

  @GetMapping("/{id}")
  public Person fetchPerson(@PathVariable UUID id) {
    return personRepository
        .findById(id)
        .map(personMapper::toModel)
        .orElseThrow(() -> new RuntimeException("Person not found"));
  }

  @PostMapping
  public Person createPerson(@RequestBody Person person) {
    PersonEntity entity = personMapper.toEntity(person);
    if (Objects.isNull(entity.getId())) {
      entity.setId(UUID.randomUUID());
    }
    Person model = personMapper.toModel(personRepository.save(entity));
    Span currentSpan = Span.current();
    currentSpan.addEvent("person.create", Attributes.of(
            AttributeKey.stringKey("person.id"), entity.getId().toString()));
    currentSpan.setAttribute("person.name", entity.getFirstName() + " " + entity.getLastName());
    return model;
  }

  @GetMapping
  public Page<Person> fetchAllPersons(
      @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size) {
    return personRepository.findAll(PageRequest.of(page, size)).map(personMapper::toModel);
  }
}
