FROM maven:3.9.9-eclipse-temurin-21-alpine AS build

ARG VERSION=1.0.0


COPY / /app/petclinic
RUN sed -i "s/VERSION/$VERSION/g" /app/petclinic/pom.xml

WORKDIR /app/petclinic

RUN mvn install -DskipTests

FROM eclipse-temurin:21-alpine

ARG VERSION=1.0.0

COPY --from=build /app/petclinic/target/petclinic-$VERSION.jar /app/petclinic.jar
#COPY /src/main/resources/application.properties /app/application.properties

WORKDIR /app
CMD ["java", "-jar", "/app/petclinic.jar"]
