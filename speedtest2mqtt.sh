#!/bin/bash
MQTT_HOST=${MQTT_HOST:-localhost}
MQTT_ID=${MQTT_ID:-k77}
MQTT_TOPIC=${MQTT_TOPIC:-speedtest/k77}
MQTT_OPTIONS=${MQTT_OPTIONS:-"-V mqttv311"}
MQTT_USER=${MQTT_USER:-user}
MQTT_PASS=${MQTT_PASS:-pass}
SPEEDTEST_OPTIONS=${SPEEDTEST_OPTIONS:-"--simple"}

#sends speedtest-cli data as json to MQTT broker
/usr/bin/speedtest-cli ${SPEEDTEST_OPTIONS} | /usr/bin/perl -pe 's/^(.*): (.*) (.*?)(\/s)?\n/"$1_$3": $2, /m' | cut -d',' -f 1-3 | while read line
do
  # Raw message to MQTT
  echo "{$line}"  | /usr/bin/mosquitto_pub -h ${MQTT_HOST} -i ${MQTT_ID} -l -t ${MQTT_TOPIC} ${MQTT_OPTIONS} -u ${MQTT_USER} -P ${MQTT_PASS}
done
