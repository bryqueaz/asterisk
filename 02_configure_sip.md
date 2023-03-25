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

## Configurar una extesion sip en modo CDR
* `cd /etc/asterisk`
* `sudo touch sip_manual.conf`
* Incluir el siguiente contenido en el archivo `sip_manual.conf`
```
[1010]
host=dynamic
secret=1010
type=friend
insecure=port,invite
disallow=all
qualify=yes
canreinvite=no
nat=no
dtmfmode=rfc2833
;allow=gsm&g729
;transport=udp,ws,wss
allow=ulaw
insecure=invite
;nat=force_rport,comedia
```
* `sudo /etc/init.d/asterisk restart`




