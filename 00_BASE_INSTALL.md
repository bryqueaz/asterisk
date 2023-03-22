# Proceso de instalación de asterisk(manual)

Cambio de nombre del server
```
sudo hostnamectl set-hostname asterisk

```
Verificar que /etc/hosts, tenga la IPV4 privada

```
ubuntu@asterisk:~$ cat /etc/hosts | grep asterisk
x.x.x.x asterisk

```

Actualizar repos

```
sudo apt-get update

```
## Instalacion de asterisk en Ubuntu 20.04.5 LTS -> asterisk-certified-16.8-cert14

* `cd /usr/src`
* `sudo apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev git subversion`
* `sudo apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev git subversion`
* `sudo systemctl reboot`
* `apt-cache search mysql`
* `sudo apt-get install mysql-server`
* `sudo apt-get install mysql-client`
* `apt-get install unixodbc`
* `apt-get install nginx`
* `sudo wget https://downloads.asterisk.org/pub/telephony/certified-asterisk/releases/asterisk-certified-16.8-cert14.tar.gz`
* `sudo tar -xvzf asterisk-certified-16.8-cert14.tar.gz`
* `cd /usr/src/asterisk-certified-16.8-cert14`
* `cd /usr/src/asterisk-certified-16.8-cert14/contrib/scripts`
* `sudo ./install_prereq install`
* `sudo apt-get update`
* `sudo systemctl reboot`

## Configuracion de asterisk en Ubuntu 20.04.5 LTS -> asterisk-certified-16.8-cert14

* `cd /usr/src/asterisk-certified-16.8-cert14`
* `sudo ./configure`
* `sudo make menuselect`
* `sudo make`
* `sudo make install`
* `sudo make samples`
* `sudo make config`
* `sudo ldconfig`
* `sudo groupadd asterisk`
* `sudo useradd -d /var/lib/asterisk -g asterisk asterisk`
* `sudo sed -i 's/#AST_USER="asterisk"/AST_USER="asterisk"/g' /etc/default/asterisk`
* `sudo sed -i 's/#AST_GROUP="asterisk"/AST_GROUP="asterisk"/g' /etc/default/asterisk`
* `sudo sed -i 's/;runuser = asterisk/runuser = asterisk/g' /etc/asterisk/asterisk.conf`
* `sudo sed -i 's/;rungroup = asterisk/rungroup = asterisk/g' /etc/asterisk/asterisk.conf`
* `sudo chown -R asterisk:asterisk /var/spool/asterisk /var/run/asterisk /etc/asterisk /var/{lib,log,spool}/asterisk /usr/lib/asterisk`
* `sudo systemctl reboot`

## Prueba de conectividad de asterisk en Ubuntu 20.04.5 LTS -> asterisk-certified-16.8-cert14

* `sudo asterisk -vvvvrc`
* `reload`
* `dialplan reload`
* `queue show`


