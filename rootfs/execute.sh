#!/usr/bin/with-contenv bashio

HOST=$(bashio::services mqtt "host")
USERNAME=$(bashio::services mqtt "username")
PASSWORD=$(bashio::services mqtt "password")

sed -e "s/\${host}/${HOST}/" -e "s/\${username}/${USERNAME}/" -e "s/\${password}/${PASSWORD}/" config.yml.dist > config.yml

node otg2mqtt.js
