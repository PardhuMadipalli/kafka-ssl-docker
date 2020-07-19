# Kafka broker with SSL enabled using Docker

## Quickstart
1. Ruild the docker image using `docker build -t kafka-ssl-image`
2. Run the container using `docker run --net=host --init -d --name=kafkassl kafka-ssl-image`
3. Access the generated key store file by using command `docker cp kafkassl:/kafka_2.12-2.5.0/ssl/server.keystore.jks keystore.jks`
4. Default password for keystore is `password`

### Environment variables
| Variable | Default value | Importance |Description |
|:--------:|:-------------:|:----------:|:---------- |
| PASSWORD | password | HIGH |The password that will be used to create keystore file. Must be 8 or more characters. |
| DOMAIN | www.mywebsite.com | HIGH |Domain name to be used while creating the certificate. This is important as certificates will be verified based on domain name. |
| KAFKA_HOME | /kafka_2.12-2.5.0/ | LOW | Directory where Kafka is installed inside the container. |
| KEY_STORE | /kafka_2.12-2.5.0/ssl/server.keystore.jks | LOW | Keystore jks file path to be used inside docker container. The file will be create if it does not exist. | 

Example: `docker run --net=host --init -d --name=kafkassl -e PASSWORD=abc123def kafka-ssl-image`

#### Testing new readme

| Header1 | Header2 | Header3 |
|:--------|:-------:|--------:|
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |
|----
| cell1   | cell2   | cell3   |
| cell4   | cell5   | cell6   |

### Purpose
- The primary purpose of the project is to create a kafka container with SSL enabled.
- The secondary goal of the project is to learn various docker commands and an important supervisor process called **runit**

## Description

### Used tools

- Java (openJDK)
- Openssl
- runit
