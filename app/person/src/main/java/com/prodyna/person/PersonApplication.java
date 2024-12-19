package com.prodyna.person;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(
    scanBasePackages = "com.prodyna.person, com.prodyna.person.core, com.prodyna.person.domain")
public class PersonApplication {
  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(PersonApplication.class.class);
    app.setBannerMode(Banner.Mode.OFF);
    app.run(args);
  }
}
