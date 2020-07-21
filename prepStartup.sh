#!/bin/bash

# Ensure all environment variables are properly configured.
: "${KAFKA_HOME=/kafka_2.12-2.5.0}"
: "${KEY_STORE=$KAFKA_HOME/ssl/server.keystore.jks}"
: "${DOMAIN=www.mywebsite.com}"
: "${PASSWORD=abc123def}"

echo "KAFKA_HOME=$KAFKA_HOME KEY_STORE=$KEY_STORE DOMAIN=$DOMAIN PASSWORD=$PASSWORD"

# If the directory does not exist, use default KAFKA_HOME
[[ -d ${KAFKA_HOME} ]] || KAFKA_HOME=/kafka_2.12-2.5.0

# Create keystore, if the file does not exist
if [[ ! -f $KEY_STORE ]]; then
    echo "No keystore file is found; hence creating a new one at $KAFKA_HOME/ssl/"

    mkdir -p $KAFKA_HOME/ssl/
    cd $KAFKA_HOME/ssl/

    keytool -keystore server.keystore.jks -alias $DOMAIN -validity 365 -genkey -keyalg RSA -dname "CN=$DOMAIN, OU=orgunit, O=Organisation, L=bangalore, S=Karnataka, C=IN" -ext SAN=DNS:$DOMAIN -keypass $PASSWORD -storepass $PASSWORD && \
    openssl req -new -x509 -keyout ca-key -out ca-cert -days 365 -passout pass:"$PASSWORD" -subj "/CN=$DOMAIN" && \
    keytool -keystore server.keystore.jks -alias CARoot -import -file ca-cert -storepass $PASSWORD -noprompt && \
    keytool -keystore server.keystore.jks -alias $DOMAIN -certreq -file cert-file -storepass $PASSWORD && \
    openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out cert-signed -days 365 -CAcreateserial -passin pass:$PASSWORD && \
    keytool -keystore server.keystore.jks -alias $DOMAIN -import -file cert-signed -storepass $PASSWORD
    echo "generated keystore file is ${KEY_STORE}"
    cd /
fi

# Copy server.properties to the relevant config directory
if [[ ! -f $KAFKA_HOME/config/server.proprties ]]; then
    cd $KAFKA_HOME
    cp /serverssl.properties ./config/
    sed -i "s|<WEBSITE>|${DOMAIN}|g" ./config/serverssl.properties
    sed -i "s|<PASSWORD>|${PASSWORD}|g" ./config/serverssl.properties
    sed -i "s|<KEYSTORELOCATION>|${KEY_STORE}|g" ./config/serverssl.properties
fi