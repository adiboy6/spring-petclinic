FROM openjdk:8
COPY target/*.jar /spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar
EXPOSE 8080:8080
CMD ["java","-Dspring.profiles.active=mysql","-jar","spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]