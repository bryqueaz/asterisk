# Proceso de instalación de asterisk(manual)

Cambio de nombre del server
```
sudo hostnamectl set-hostname asterisk

```
Actualizar repos

```
sudo apt-get update

```
## Instalacion de asterisk en Ubuntu -> asterisk-certified-16.8-cert14

* `cd /usr/src`
* `sudo wget https://downloads.asterisk.org/pub/telephony/certified-asterisk/releases/asterisk-certified-16.8-cert14.tar.gz`
* `sudo tar -xvzf asterisk-certified-16.8-cert14.tar.gz`
* `cd /usr/src/asterisk-certified-16.8-cert14`
* `cd /usr/src/asterisk-certified-16.8-cert14/contrib/scripts`
* `sudo ./install_prereq install`
* `sudo apt-get update`
* `sudo systemctl reboot`

