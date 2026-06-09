SUMMARY = "Minimal Raspberry Pi image with Mosquitto MQTT broker"
DESCRIPTION = "Purpose-built embedded Linux image running Mosquitto as a systemd service. \
No GUI, no unnecessary packages — designed as a lightweight MQTT broker node."
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += "ssh-server-openssh"

IMAGE_INSTALL:append = " \
    mosquitto \
    mosquitto-clients \
    python3 \
    python3-paho-mqtt \
    mqtt-healthcheck \
    htop \
    nano \
"

# Keep image size small
IMAGE_ROOTFS_SIZE ?= "524288"
IMAGE_OVERHEAD_FACTOR ?= "1.3"

# Hostname
hostname:pn-base-files = "mqtt-broker"
