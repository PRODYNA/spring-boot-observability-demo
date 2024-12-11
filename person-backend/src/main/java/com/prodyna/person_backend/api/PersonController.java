package com.prodyna.person_backend.api;

import com.prodyna.person_backend.core.PersonEntity;
import com.prodyna.person_backend.core.PersonMapper;
import com.prodyna.person_backend.core.PersonRepository;
import com.prodyna.person_backend.domain.Person;
import java.util.Objects;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/person")
@RequiredArgsConstructor
public class PersonController {

  private final PersonRepository personRepository;

  private final PersonMapper personMapper;

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
    return personMapper.toModel(personRepository.save(entity));
  }

  @GetMapping
  public Page<Person> fetchAllPersons(
      @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size) {
    return personRepository.findAll(PageRequest.of(page, size)).map(personMapper::toModel);
  }
}
