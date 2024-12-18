package com.prodyna.person_backend.domain;

import java.time.LocalDate;
import java.util.UUID;

public record Person(UUID id, String firstName, String lastName, LocalDate birthDate) {}
