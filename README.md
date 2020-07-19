![](https://github.com/PardhuMadipalli/kafka-ssl-docker/workflows/Publish%20Docker%20image/badge.svg
# Kafka broker with SSL enabled using Docker
- [Table of Contents](#kafka-broker-with-ssl-enabled-using-docker)
  * [Quickstart](#quickstart)
    + [Environment variables](#environment-variables)
    + [Purpose](#purpose)
  * [Description](#description)
    + [Used tools](#used-tools)
    
## Quickstart
1. Ruild the docker image using `docker build -t kafka-ssl-image`
2. Run the container using `docker run --net=host --init -d --name=kafkassl kafka-ssl-image`
3. Access the generated key store file by using command `docker cp kafkassl:/kafka_2.12-2.5.0/ssl/server.keystore.jks keystore.jks`
4. Default password for keystore is `password`

### Environment variables

| Variable   | Default value                             | Importance | Description                                                                                | 
|:----------:|:-----------------------------------------:|:----------:|:-------------------------------------------------------------------------------------------|
| PASSWORD   | password                                  | HIGH       | The password that will be used to create keystore file. Must be 8 or more characters.      |
| DOMAIN     | www.mywebsite.com                         | HIGH       | Domain name to be used while creating the certificate.                                     |
| KAFKA_HOME | /kafka_2.12-2.5.0/                        | LOW        | Directory where Kafka is installed inside the container.                                   |
| KEY_STORE  | /kafka_2.12-2.5.0/ssl/server.keystore.jks | LOW        | Keystore jks file path to be used inside docker container.                                 | 


Example: `docker run --net=host --init -d --name=kafkassl -e PASSWORD=abc123def kafka-ssl-image`


### Purpose
- The primary purpose of the project is to create a kafka container with SSL enabled.
- The secondary goal of the project is to learn various docker commands and an important supervisor process called **runit**

## Description

### Used tools

- Java (openJDK)
- Openssl
- runit
