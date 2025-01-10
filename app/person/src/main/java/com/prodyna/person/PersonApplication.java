package com.prodyna.person;

import static org.springframework.data.web.config.EnableSpringDataWebSupport.PageSerializationMode.VIA_DTO;

import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

@SpringBootApplication
@EnableSpringDataWebSupport(pageSerializationMode = VIA_DTO)
public class PersonApplication {
  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(PersonApplication.class);
    app.setBannerMode(Banner.Mode.OFF);
    app.run(args);
  }
}
