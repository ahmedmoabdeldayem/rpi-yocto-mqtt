#!/bin/sh
# Smoke test for the local Mosquitto broker.
# Subscribes for 3 seconds while publishing a ping; exits 0 if the message
# is echoed back, 1 otherwise.

BROKER="localhost"
TOPIC="healthcheck/ping"
PAYLOAD="ping-$(date +%s)"
RESULT_FILE="/tmp/mqtt-healthcheck-$$"

# Subscribe in background, write result to a temp file
mosquitto_sub -h "$BROKER" -t "$TOPIC" -C 1 -W 3 > "$RESULT_FILE" &
SUB_PID=$!

sleep 0.2
mosquitto_pub -h "$BROKER" -t "$TOPIC" -m "$PAYLOAD"

wait $SUB_PID
RESULT=$(cat "$RESULT_FILE")
rm -f "$RESULT_FILE"

if [ "$RESULT" = "$PAYLOAD" ]; then
    echo "MQTT broker OK: $BROKER"
    exit 0
else
    echo "MQTT broker health check FAILED"
    exit 1
fi
