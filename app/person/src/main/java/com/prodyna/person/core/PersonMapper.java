package com.prodyna.person.core;

import com.prodyna.person.domain.Person;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PersonMapper {

  Person toModel(PersonEntity entity);

  PersonEntity toEntity(Person model);
}
