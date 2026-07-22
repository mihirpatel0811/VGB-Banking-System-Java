# ==============================================================================
# STAGE 1: Build the WAR application using Maven
# ==============================================================================
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /build

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the WAR application
RUN mvn clean package -DskipTests

# ==============================================================================
# STAGE 2: Run the WAR application on Tomcat 10.1 (Jakarta EE 10 / Servlet 6.0)
# ==============================================================================
FROM tomcat:10.1-jdk17-temurin-alpine

LABEL maintainer="VGB Banking Team"
LABEL description="Vertex Galaxy Bank Digital Banking Application"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled WAR from builder stage as ROOT.war
COPY --from=builder /build/target/VGB-Banking-System-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat HTTP port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
