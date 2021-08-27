sudo su
apt-get install lm-sensors
apt-get install thinkfan
echo "options thinkpad_acpi fan_control=1" > /etc/modprobe.d/thinkpad_acpi.conf
modprobe thinkpad_acpi

