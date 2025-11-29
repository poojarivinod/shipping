FROM maven AS builder
WORKDIR /opt/server
COPY pom.xml /opt/server
COPY src /opt/server/src
RUN mvn clean package
RUN ls -ltr target

FROM eclipse-temurin:17-jre-alpine
EXPOSE 8080
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    mkdir /opt/server && \
    chown -R roboshop:roboshop /opt/server
WORKDIR /opt/server
COPY --from=builder /opt/server/target/shipping-1.0.jar /opt/server/shipping.jar
USER roboshop
CMD ["java", "-jar", "shipping.jar"]
