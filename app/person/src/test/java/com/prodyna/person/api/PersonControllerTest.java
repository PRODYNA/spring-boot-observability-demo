package com.prodyna.person.api;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.notNullValue;

import com.prodyna.person.AbstractIntegrationTest;
import com.prodyna.person.domain.Person;
import io.restassured.http.ContentType;
import java.time.LocalDate;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

public class PersonControllerTest extends AbstractIntegrationTest {

  @Test
  public void testCreatePerson() {
    Person person = new Person(UUID.randomUUID(), "John", "Doe", LocalDate.of(1990, 1, 1));

    given()
        .contentType(ContentType.JSON)
        .body(person)
        .when()
        .post("/")
        .then()
        .log()
        .body()
        .statusCode(HttpStatus.OK.value())
        .body("id", notNullValue())
        .body("firstName", equalTo("John"))
        .body("lastName", equalTo("Doe"))
        .body("birthDate", equalTo("1990-01-01"));
  }
}
