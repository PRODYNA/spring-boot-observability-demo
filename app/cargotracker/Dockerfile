FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src src/
RUN mvn clean package -DskipTests
RUN ls -lF /app/

FROM open-liberty:latest
COPY --from=build /app/target/cargo-tracker.war /config/dropins/

