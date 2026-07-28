# ==============================================================================
# Run the WAR application on Tomcat 10.1 (Jakarta EE 10 / Servlet 6.0)
# ==============================================================================
FROM tomcat:10.1-jdk17-temurin

LABEL maintainer="VGB Banking Team"
LABEL description="Vertex Galaxy Bank Digital Banking Application"

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy compiled WAR as ROOT.war
COPY target/VGB-Banking-System-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat HTTP port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
