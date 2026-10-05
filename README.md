# rpi-yocto-mqtt

A minimal Yocto meta-layer that builds a purpose-built embedded Linux image for Raspberry Pi 4 running Mosquitto as a dedicated MQTT broker node.

No GUI, no unnecessary packages — the image boots straight into a systemd-managed Mosquitto service.

## What's in the image

| Package | Purpose |
|---|---|
| `mosquitto` | MQTT broker (systemd service, auto-start on boot) |
| `mosquitto-clients` | `mosquitto_pub` / `mosquitto_sub` CLI tools |
| `python3` + `python3-paho-mqtt` | For client scripts on the broker node |
| `mqtt-healthcheck` | Smoke-test script to verify the broker is running |
| `ssh-server-openssh` | Remote access |

## Quick Start

### 1. Set up the Yocto build environment

```bash
# Clone Poky + required layers (adjust paths to taste)
git clone https://git.yoctoproject.org/poky             /opt/yocto/poky
git clone https://github.com/openembedded/meta-openembedded /opt/yocto/meta-openembedded
git clone https://github.com/agherzan/meta-raspberrypi  /opt/yocto/meta-raspberrypi

# Clone this repo
git clone https://github.com/ahmedmoabdeldayem/rpi-yocto-mqtt
cd rpi-yocto-mqtt

# Initialise the build environment
source /opt/yocto/poky/oe-init-build-env build
```

### 2. Configure the build

```bash
cp build/conf/bblayers.conf.template build/conf/bblayers.conf
cp build/conf/local.conf.template    build/conf/local.conf
# Edit both files to match your layer paths
```

### 3. Build and flash

```bash
bitbake rpi-mqtt-image

# Flash to SD card (replace /dev/sdX with your card)
sudo dd if=tmp/deploy/images/raspberrypi4-64/rpi-mqtt-image-raspberrypi4-64.wic \
        of=/dev/sdX bs=4M status=progress conv=fsync
```

### 4. First boot — set up MQTT credentials

```bash
ssh root@<pi-ip>
mosquitto_passwd -c /etc/mosquitto/passwd <username>
systemctl restart mosquitto
```

### 5. Verify the broker

```bash
mqtt-healthcheck   # exits 0 if broker is responding
```

## Layer Structure

```
meta-rpi-mqtt/
├── conf/layer.conf                          # Layer metadata (kirkstone + scarthgap)
├── recipes-connectivity/mosquitto/
│   ├── mosquitto_%.bbappend                 # Deploys config + enables service
│   └── files/mosquitto.conf                 # Secure defaults (auth required)
├── recipes-core/images/
│   └── rpi-mqtt-image.bb                    # Image recipe
└── recipes-scripts/mqtt-healthcheck/
    ├── mqtt-healthcheck.bb
    └── files/mqtt-healthcheck.sh            # Broker smoke test
```

## Compatibility

| Yocto Release | Status |
|---|---|
| Kirkstone (4.0 LTS) | Supported |
| Scarthgap (5.0 LTS) | Supported |
