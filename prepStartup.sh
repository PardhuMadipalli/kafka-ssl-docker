#!/bin/bash


NOCOLOR='\033[0m'
RED='\033[0;31m'

function exitWithError() {
  printf "${RED}%s\n${NOCOLOR}" "$1" >&2
  exit 1
}

if [[ -z $KAFKA_HOME ]]; then
    echo "KAFKA_HOME is not specified. Hence using default location: /kafka_2.12-2.5.0"
	KAFKA_HOME="/kafka_2.12-2.5.0"
fi

if [[ -z $KEY_STORE ]]; then
	KEY_STORE="$KAFKA_HOME/ssl/server.keystore.jks"
fi

if [[ -z $DOMAIN ]]; then
	echo "DOMAIN is not set, using www.mywebsite.com"
	DOMAIN=www.mywebsite.com
fi

if [[ -z $PASSWORD ]]; then
        echo "PASSWORD is not set, using abc123def"
        PASSWORD=abc123def
else
    echo "Using password: $PASSWORD"
fi


if [[ ! -f $KEY_STORE ]]; then
    echo "No keystore file is found; hence creating a new one at $KAFKA_HOME/ssl/"

    mkdir -p $KAFKA_HOME/ssl/
    cd $KAFKA_HOME/ssl/ || exitWithError "KAFKA_HOME/ssl directory does not exist"

    keytool -keystore server.keystore.jks -alias $DOMAIN -validity 365 -genkey -keyalg RSA -dname "CN=$DOMAIN, OU=orgunit, O=Organisation, L=bangalore, S=Karnataka, C=IN" -ext SAN=DNS:$DOMAIN -keypass $PASSWORD -storepass $PASSWORD && \
    openssl req -new -x509 -keyout ca-key -out ca-cert -days 365 -passout pass:"$PASSWORD" -subj "/CN=$DOMAIN" && \
    keytool -keystore server.keystore.jks -alias CARoot -import -file ca-cert -storepass $PASSWORD -noprompt && \
    keytool -keystore server.keystore.jks -alias $DOMAIN -certreq -file cert-file -storepass $PASSWORD && \
    openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:$PASSWORD && \
    keytool -keystore server.keystore.jks -alias $DOMAIN -import -file cert-signed -storepass $PASSWORD
    echo "generated keystore file is ${KEY_STORE}"
    cd /
fi

if [[ ! -f $KAFKA_HOME/config/server.proprties ]]; then
    cd $KAFKA_HOME || exitWithError "KAFKA_HOME directory does not exist"
    cp /serverssl.properties ./config/
    sed -i "s|<WEBSITE>|${DOMAIN}|g" ./config/serverssl.properties
    sed -i "s|<PASSWORD>|${PASSWORD}|g" ./config/serverssl.properties
    sed -i "s|<KEYSTORELOCATION>|${KEY_STORE}|g" ./config/serverssl.properties
fi
