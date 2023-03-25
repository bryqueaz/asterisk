# Configurar la extesion SIP y el dialplan
* `cd /etc/asterisk`
* Editar el lenguaje, buscar la definicion `defaultlanguage` y cambiar a espanol, para el file `/etc/asterisk/asterisk.conf`

```
root@asterisk:/etc/asterisk# cat asterisk.conf  | grep defaultlanguage
;;defaultlanguage = en           ; Default language
defaultlanguage = es           ; Default language
```
# Ejemplo de como realiza un respaldo de la configuracion de asterisk

* `sudo mkdir /var/backups_all/`
* `sudo scp -r /etc/asterisk /var/backups/asterisk_old`

# Configurar la extesion sip

Borrar toda la informacion del archivo `/etc/asterisk/sip.conf`

Y definir el siguiente en el archivo `/etc/asterisk/sip.conf`

Se deben cambiar los valores de las siguientes defincioes:

* **externip=**
* **localnet=**

```
[general]
context=greencore
bindport=5060

; webrtc
;udpbindaddr=0.0.0.0:5060
;realm=3.211.79.51;
transport=udp

; fin webrtc

externip=ip_publica
localnet=ip_interna

srvlookup=no
disallow=all
;allow=g729
allow=ulaw
allow=alaw
;allow=gsm
nat=force_rport,comedia
language=es
rtcachefriends=yes
#include sip_manual.conf
```




