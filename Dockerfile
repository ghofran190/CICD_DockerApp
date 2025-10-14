
FROM eclipse-temurin:17-jre-alpine

# Définir un argument pour le JAR
ARG JAR_FILE=target/*.jar

# Copier le jar dans l'image
COPY ${JAR_FILE} app.jar

# Définir la commande pour lancer le jar
ENTRYPOINT ["java", "-jar", "/app.jar"]

# Exposer le port sur lequel Spring Boot tourne
EXPOSE 8080