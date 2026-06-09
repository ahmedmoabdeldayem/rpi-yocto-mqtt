FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://mosquitto.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/mosquitto
    install -m 0644 ${WORKDIR}/mosquitto.conf ${D}${sysconfdir}/mosquitto/mosquitto.conf
    # Ensure persistence directory exists
    install -d ${D}${localstatedir}/lib/mosquitto
}

# Enable mosquitto service on boot via systemd
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "mosquitto.service"
