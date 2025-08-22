FROM maven:3.9-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk17-temurin
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
