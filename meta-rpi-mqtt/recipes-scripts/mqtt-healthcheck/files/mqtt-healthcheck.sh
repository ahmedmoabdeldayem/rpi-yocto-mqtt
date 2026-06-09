#!/bin/sh
# Smoke test for the local Mosquitto broker.
# Subscribes for 2 seconds while publishing a ping; exits 0 if the message
# is echoed back, 1 otherwise.

BROKER="localhost"
TOPIC="healthcheck/ping"
PAYLOAD="ping-$(date +%s)"

# Subscribe in background, capture one message
RESULT=$(mosquitto_sub -h "$BROKER" -t "$TOPIC" -C 1 -W 3 &)
SUB_PID=$!

sleep 0.2
mosquitto_pub -h "$BROKER" -t "$TOPIC" -m "$PAYLOAD"

wait $SUB_PID
if [ "$RESULT" = "$PAYLOAD" ]; then
    echo "MQTT broker OK: $BROKER"
    exit 0
else
    echo "MQTT broker health check FAILED"
    exit 1
fi
