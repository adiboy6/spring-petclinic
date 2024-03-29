FROM openjdk:8
USER root
COPY target/*.jar /spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar
COPY --chown=root wait-for-it.sh /
EXPOSE 8080:8080
CMD   ["./wait-for-it.sh","mysql:3306","--","java","-Dspring.profiles.active=mysql","-jar","spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]