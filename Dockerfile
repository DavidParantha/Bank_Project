# Build Stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run Stage
FROM tomcat:10.1-jdk21-temurin-jammy
WORKDIR /usr/local/tomcat

# Disable Tomcat shutdown port to prevent Render health checks hitting the wrong port
RUN sed -i 's/port="8005"/port="-1"/' conf/server.xml

# Remove default webapps
RUN rm -rf webapps/*

# Copy the built WAR file to Tomcat's webapps directory
COPY --from=build /app/target/LaceBank.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
