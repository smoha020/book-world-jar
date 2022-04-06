FROM openjdk:8
ADD target/springboot-kubernetes.jar springboot-kubernetes.jar
COPY /src /src
ENTRYPOINT ["java", "-jar", "springboot-kubernetes.jar"]
