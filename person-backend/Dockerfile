FROM maven:3.9.9-eclipse-temurin-21-alpine AS build

COPY / /app

WORKDIR /app

RUN mvn clean package
