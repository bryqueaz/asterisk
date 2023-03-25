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

Y definir lo siguiente en el archivo `/etc/asterisk/sip.conf`

Se deben cambiar los valores de las siguientes definiciones:

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

Importante se debe cambiar el valor de **1010** por el valor de la extesion que corresponda. 

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

## Modificar el archivo de extensions

Borrar toda la informacion del archivo `/etc/asterisk/extensions.conf`

Y definir lo siguiente en el archivo `/etc/asterisk/extensions.conf`

* `cd /etc/asterisk`

```
[general]
static=yes
writeprotect=no
clearglobalvars=no

[globals]
;######VARIABLES GLOBALES ASTERISK
#include var_globales.conf


;######ARCHIVOS DINAMICOS
#include route_out.conf
;#include greencore/route_out.conf
;#include greencore/route_in.conf

;###### MACRO DE GRABACION
;#include macros.conf

;###### CONTEXTO DE ENTRADA
[greencore]
include => interno
```
Ejecutar los siguientes desde la consola, creacion de archivos y permisos

```
ubuntu@asterisk:/etc/asterisk$ sudo touch  var_globales.conf
ubuntu@asterisk:/etc/asterisk$ sudo touch  troncales.conf
ubuntu@asterisk:/etc/asterisk$ sudo touch  route_out.conf
ubuntu@asterisk:/etc/asterisk$ sudo chown asterisk:asterisk var_globales.conf troncales.conf route_out.conf
```

* `sudo vim /etc/asterisk/var_globales.conf`

```
CONSOLE=Console/dsp

;CID_GLO=43220887
;CID_FIJ=43220887

; celular 1
;TCE1=intico_out

LIMITCALL=300000
```
* `sudo vim /etc/asterisk/troncales.conf`



```
[config](!)
type=friend
insecure=port,invite
disallow=all
qualify=yes
canreinvite=no
nat=no

[trunk_out](config)
host=181.143.53.2
dtmfmode=rfc2833
;allow=gsm&g729
;transport=udp,ws,wss
allow=ulaw
insecure=invite
;nat=force_rport,comedia

[trunk_green](config)
host=sip.interphone.cr
dtmfmode=rfc2833
;allow=gsm&g729
;transport=udp,ws,wss
allow=ulaw
insecure=invite
;nat=force_rport,comedia
user=217503
secret=EJsx6bE009dG
```

## Reload de la consola de asterisk

* `$ sudo asterisk -vvvvvrc`
* `sip reload`

```
ubuntu@asterisk:~$ sudo asterisk -vvvvvrc
Asterisk certified/16.8-cert14, Copyright (C) 1999 - 2021, Sangoma Technologies Corporation and others.
Created by Mark Spencer <markster@digium.com>
Asterisk comes with ABSOLUTELY NO WARRANTY; type 'core show warranty' for details.
This is free software, with components licensed under the GNU General Public
License version 2 and other licenses; you are welcome to redistribute it under
certain conditions. Type 'core show license' for details.
=========================================================================
Running as user 'asterisk'
Running under group 'asterisk'
Connected to Asterisk certified/16.8-cert14 currently running on asterisk (pid = 83216)
asterisk*CLI> sip reload
```








