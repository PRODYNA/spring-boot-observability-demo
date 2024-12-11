package com.prodyna.person_backend.core;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.time.LocalDate;
import java.util.UUID;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Entity(name = "Person")
@Getter
@Setter
@EqualsAndHashCode
public class PersonEntity {
  @Id private UUID id;
  private String firstName;
  private String lastName;
  private LocalDate birthDate;
}
