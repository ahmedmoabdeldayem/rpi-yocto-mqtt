SUMMARY = "MQTT broker health check utility"
DESCRIPTION = "Shell script that publishes a test message to verify the broker is running. \
Intended to run post-boot as a simple smoke test."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://mqtt-healthcheck.sh"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/mqtt-healthcheck.sh ${D}${bindir}/mqtt-healthcheck
}

FILES:${PN} = "${bindir}/mqtt-healthcheck"

RDEPENDS:${PN} = "mosquitto-clients"
