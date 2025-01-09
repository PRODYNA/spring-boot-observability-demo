package com.prodyna.person;

import static org.springframework.data.web.config.EnableSpringDataWebSupport.PageSerializationMode.VIA_DTO;

import com.prodyna.person.config.TraceFilter;
import org.springframework.boot.Banner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

@SpringBootApplication
@EnableSpringDataWebSupport(pageSerializationMode = VIA_DTO)
public class PersonApplication {
  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(PersonApplication.class);
    app.setBannerMode(Banner.Mode.OFF);
    app.run(args);
  }

  @Bean
  public FilterRegistrationBean<TraceFilter> loggingFilter() {
    FilterRegistrationBean<TraceFilter> registrationBean = new FilterRegistrationBean<>();
    registrationBean.setFilter(new TraceFilter());
    registrationBean.addUrlPatterns("/*");
    return registrationBean;
  }
}
