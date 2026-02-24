# ---- Stage 1: Build the WAR file ----
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
# Download dependencies first (cached layer)
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

# ---- Stage 2: Run on Tomcat ----
FROM tomcat:10.1-jdk21-temurin-jammy

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the builder stage
COPY --from=builder /app/target/LaceBank.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port Render will use
EXPOSE 8080

CMD ["catalina.sh", "run"]
