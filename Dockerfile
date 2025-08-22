# Use official Tomcat with OpenJDK
FROM tomcat:10.1-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create app directory and copy source
WORKDIR /app
COPY . .

# Install Maven, build the WAR, and clean up in single layer
RUN apt-get update && \
    apt-get install -y maven && \
    mvn clean package -DskipTests && \
    cp target/demo-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war && \
    apt-get remove -y maven && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /app

# Fix shutdown warnings by disabling shutdown port
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8080
CMD ["catalina.sh", "run"]
