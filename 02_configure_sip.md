# Configurar la extesion SIP y el dialplan
* `cd /etc/asterisk`
* Editar el lenguaje, buscar la definicion `defaultlanguage` y cambiar a espanol, para el file `/etc/asterisk/asterisk.conf`

```
root@asterisk:/etc/asterisk# cat asterisk.conf  | grep defaultlanguage
;;defaultlanguage = en           ; Default language
defaultlanguage = es           ; Default language
```
