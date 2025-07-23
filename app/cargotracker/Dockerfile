FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src src/
RUN mvn clean package -DskipTests

#FROM icr.io/appcafe/open-liberty:latest
FROM openliberty/open-liberty:25.0.0.6-full-java17-openj9-ubi
COPY --from=build /app/target/cargo-tracker.war /config/dropins/
COPY src/main/liberty/config /config/
