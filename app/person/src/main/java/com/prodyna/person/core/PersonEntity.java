package com.prodyna.person.core;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.time.LocalDate;
import java.util.Objects;
import java.util.UUID;

@Entity(name = "Person")
public class PersonEntity {
  @Id private UUID id;
  private String firstName;
  private String lastName;
  private LocalDate birthDate;

  public UUID getId() {
    return id;
  }

  public PersonEntity setId(UUID id) {
    this.id = id;
    return this;
  }

  public String getFirstName() {
    return firstName;
  }

  public PersonEntity setFirstName(String firstName) {
    this.firstName = firstName;
    return this;
  }

  public String getLastName() {
    return lastName;
  }

  public PersonEntity setLastName(String lastName) {
    this.lastName = lastName;
    return this;
  }

  public LocalDate getBirthDate() {
    return birthDate;
  }

  public PersonEntity setBirthDate(LocalDate birthDate) {
    this.birthDate = birthDate;
    return this;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    PersonEntity that = (PersonEntity) o;
    return Objects.equals(id, that.id)
        && Objects.equals(firstName, that.firstName)
        && Objects.equals(lastName, that.lastName)
        && Objects.equals(birthDate, that.birthDate);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, firstName, lastName, birthDate);
  }
}
