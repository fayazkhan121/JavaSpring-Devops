# Use a lightweight official Maven image for building the application
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy only the pom.xml and dependencies first for better caching
COPY app/pom.xml .

# Download dependencies to leverage Docker caching
RUN mvn dependency:go-offline -B

# Copy the entire application source code to the working directory
COPY app/src ./src

# Build the application package
RUN mvn clean package -DskipTests

# Use a lightweight runtime image for the application
FROM eclipse-temurin:17-jre

# Set the working directory for the runtime container
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application's default port
EXPOSE 8080

# Define the entry point to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
