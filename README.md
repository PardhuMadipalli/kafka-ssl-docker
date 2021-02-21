![](https://github.com/PardhuMadipalli/kafka-ssl-docker/workflows/Publish%20Docker%20image/badge.svg)  ![](https://github.com/PardhuMadipalli/kafka-ssl-docker/workflows/Shellcheck/badge.svg) 

![](https://img.shields.io/docker/pulls/pardhu1212/kafka-ssl?color=brightgreen&label=Docker%20Pulls&logo=Docker)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The docker image is available on [Docker Hub](https://hub.docker.com/r/pardhu1212/kafka-ssl:0.1.0)

Run this command to pull the image: **`docker pull pardhu1212/kafka-ssl:0.1.0`**

# Kafka broker with SSL enabled using Docker
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Quickstart](#quickstart)
  - [Environment variables](#environment-variables)
  - [Purpose](#purpose)
- [Description](#description)
  - [Kafka with SSL](#kafka-with-ssl)
    - [SSL](#ssl)
    - [Certificate creation and signing](#certificate-creation-and-signing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
    
## Quickstart
- Download the image from the above link 
 
 OR
 
1. Ruild the docker image using `docker build -t kafka-ssl`
2. Run the container using `docker run --init -d -p 9093:9093 -p 9094:9094 --name=kafkassl kafka-ssl`
3. Access the generated key store file by using command `docker cp kafkassl:/kafka_2.12-2.5.0/ssl/server.keystore.jks keystore.jks`
4. Default password for keystore is `password`

### Environment variables

| Variable   | Default value                             | Importance | Description                                                                                | 
|:----------:|:-----------------------------------------:|:----------:|:-------------------------------------------------------------------------------------------|
| PASSWORD   | password                                  | HIGH       | The password that will be used to create keystore file. Must be 8 or more characters.      |
| DOMAIN     | www.mywebsite.com                         | HIGH       | Domain name to be used while creating the certificate.                                     |
| KAFKA_HOME | /kafka_2.12-2.5.0/                        | LOW        | Directory where Kafka is installed inside the container.                                   |
| KEY_STORE  | /kafka_2.12-2.5.0/ssl/server.keystore.jks | LOW        | Keystore jks file path to be used inside docker container.                                 | 


Example of setting environment variable `PASSWORD`: 
```
docker run --init -d --name=kafkassl -p 9093:9093 -p 9094:9094 -e PASSWORD=abc123def pardhu1212/kafka-ssl:0.1.0
```


### Purpose
- The primary purpose of the project is to create a kafka container with SSL enabled.
- The secondary goal of the project is to learn about kafka with SSL, docker commands and an important supervisor process called **runit**.

## Description

### Kafka with SSL

In the file [prepStartup.sh](https://github.com/PardhuMadipalli/kafka-ssl-docker/blob/master/prepStartup.sh) we can notice different openssl and keytool commands. To understand what we are doing here, we need to have a basic understanding of how SSL works.

#### SSL
When a server is SSL enabled, it provides a certificate and the client validates it. When we browse for `https://www.google.com`, the Google server first responds with a certificate along with some details,
Your browser has a list of certificates(in fact Certifcate Authorities) that it will trust. Since the Google's certificate is signed by a trustworthy Certifcate Authority(CA) like Verizon, your browser allows further connection.

Kafka SSL also works in a similar way. If you create a kafka broker (an equivalent of Google server), you want to make it SSL enabled, you have to provide a certificate. This certificate should be signed by a certificate authority.
In the production use case, you have to create the certificate and mail it to an actual and trusted CA so that they will sign it. Then you can use this whenever a client tries to connect to you.

But how can we achieve this in a development scenario? Then you can create your own CA and sign your own certificate. The shell script does exactly that. It will create a certifcate, sign it with a self created CA
and store them in a keystore file. We use Keytool(provided by Java) and Openssl to create them.

#### Certificate creation and signing

- The content of the certificate file is encrypted using an algorithm. Most people use RSA and the same has been used here.
- The validity of the certifcate needs to be specified. Here the validity is chosen as 365 days from the day of creation.
- The most important details when creating the certificate is the Common Name(CN). Most clients who receive the SSL certifcate will 
verify the name of the domain with the CN of the certifcate. If it does not match, although the certificate is issued a 
trusted CA, the connection might be rejected.
