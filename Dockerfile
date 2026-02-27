# Build Stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run Stage
FROM tomcat:10.1-jdk21-temurin-jammy
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Copy the built WAR file to Tomcat's webapps directory
# The finalName in pom.xml is LaceBank, so the war is LaceBank.war
COPY --from=build /app/target/LaceBank.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
