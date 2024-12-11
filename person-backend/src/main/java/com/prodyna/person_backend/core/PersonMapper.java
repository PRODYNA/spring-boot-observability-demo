package com.prodyna.person_backend.core;

import com.prodyna.person_backend.domain.Person;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PersonMapper {

  Person toModel(PersonEntity entity);

  PersonEntity toEntity(Person model);
}
