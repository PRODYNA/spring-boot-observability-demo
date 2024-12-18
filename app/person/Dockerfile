FROM maven:3.9.9-eclipse-temurin-21-alpine AS build

ARG VERSION=1.0.0


COPY / /app/person
RUN sed -i "s/VERSION/$VERSION/g" /app/person/pom.xml

WORKDIR /app/person

RUN ./mvnw install -DskipTests

FROM eclipse-temurin:21-alpine

ARG VERSION=1.0.0

COPY --from=build /app/person/target/person-$VERSION.jar /app/person.jar
COPY /src/main/resources/application.properties /app/application.properties

CMD ["java", "-jar", "/app/person.jar"]
