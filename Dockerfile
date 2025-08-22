# -------- Stage 1: Build WAR file with Maven --------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml trước để cache dependency
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code và build WAR
COPY src ./src
RUN mvn clean package -DskipTests

# -------- Stage 2: Deploy WAR to Tomcat --------
FROM tomcat:9.0-jdk17-temurin

WORKDIR /usr/local/tomcat

# Disable shutdown port (Render hay gửi nhầm request)
RUN sed -i 's/port="8005"/port="-1"/' conf/server.xml

# Xóa app mặc định và copy WAR từ stage build
RUN rm -rf webapps/*
COPY --from=build /app/target/*.war webapps/ROOT.war

# Expose port Tomcat
EXPOSE 8080

CMD ["catalina.sh", "run"]
