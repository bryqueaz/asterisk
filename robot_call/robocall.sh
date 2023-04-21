#!/bin/bash
#########################################################################
#Ejecuta llamadas segun las caracteristicas del robocall		#
#Mario Forero    <marioforero1983@gmail.com>            		#
#Version: 1.0								#
#2023-04-19                                             		#
# 1. Debe existir directorio /var/taller/cron/				#
# 2. Debe existir directorio /var/taller/data/          		#
# 3. Debe existir directorio /var/taller/log/           		#
# 4. El formato de data es id|telefono|nombre|documento|descripcion	#
# 5. Puede comentar la linea 106 - sed, para no perder info de /data	#
# 6. Variables Robocall estan relacionadas al comportamiento		#
#	- VELOCIDAD: Cantidad en segundos entre cada grupo de llamadas	#
#	- CANANES: Cantidad de llamadas simultaneas			#
#	- RETRIES: Cantidad de Intentos despues de la llamada inicial	#
#	- RETRY: Cantidad en segundos entre cada intento		#
#		- Se recomienda que sea multiplicado x3 con el ring	#
#	- RING: Cantidad en segundos tiempo de ring			#
#########################################################################
ID=$1
ACCOUNT=$2

if [ -z ${1} ]; then echo "No existe la variable ID"; fi
if [ -z ${2} ]; then echo "No existe la variable ACCOUNT"; exit; fi


#Variables static
dialer_nombre="Robocall_${ID}"
_SALIDA='int'
_CONTEXT='ROBO'
_CALLERID='5051234567'
# Variables Robocall
_VELOCIDAD=60
_CANALES=1
_RETRIES=1
_RETRY=120
_RING=30

#DB
USER="root"
PASSWORD="Greencore123"
DATABASE="robocall"
DTg=`date '+%Y-%m-%d_%H:%M:%S_%N'`
REMOVER=120
HOSTRAPTOR="greencore.com"

# variables data
_idreg=""
_telefono=""
_nombre=""
_documento=""
_descripcion=""

chmod 777  /var/taller/data/robocall_${ID}.txt

# INICIO DEL ROBOCALL
	n=0
        while read -r resultado; do
		echo "[${DTg}]: INICIO CICLO \n" >> /var/taller/log/robocall_${ID}.log;
		((n=n+1))
		TIEMPO_INTENTO=${_VELOCIDAD}
                # variables de tiempo
                DT=`date '+%Y-%m-%d_%H:%M:%S_%N'`
                FILE="robocall-${ID}-"`date '+%Y%m%d%H%M%S%N'`

                # string to array para diferenciar id|telefono|nombre|documento|descripcion
                IFS="|" read -a arrRes <<< $resultado
		
		_idreg=${arrRes[0]}
		_telefono=${arrRes[1]}
		_nombre=${arrRes[2]}
		_documento=${arrRes[3]}
		_descripcion=${arrRes[4]}

                echo "[${DT}] ${ID} ($dialer_nombre): Marcado Telefono: ${_telefono} Archivo: ${FILE}.call " >> /var/taller/log/robocall_${ID}.log
                # se crea el archivo .call

                archivo="${archivo}Channel: Local/${_telefono}@${_SALIDA} \n";
                archivo="${archivo}MaxRetries: ${_RETRIES} \n";
                archivo="${archivo}RetryTime: ${_RETRY} \n";
		archivo="${archivo}WaitTime: ${_RING} \n";
                archivo="${archivo}Context: ${_CONTEXT} \n";
                archivo="${archivo}Extension: ${_telefono} \n";
                archivo="${archivo}Priority: 1 \n";
                archivo="${archivo}Account: ${ACCOUNT} \n";
                archivo="${archivo}Callerid: ${_CALLERID}<${_CALLERID}> \n";
                # variables
#               arcvar="${arcvar}Set: DI_TEL=${_telefono} \n";
                arcvar="${arcvar}Set: DI_TRO=100 \n";
                arcvar="${arcvar}Set: DI_ARC=${FILE} \n";
                arcvar="${arcvar}Set: DI_INT=${_RETRIES} \n";
                arcvar="${arcvar}Set: DI_TIE=${_RETRY} \n";
                arcvar="${arcvar}Set: DI_IDREG=${_idreg} \n";
                arcvar="${arcvar}Set: DI_ID=${ID} \n";
                arcvar="${arcvar}Set: DI_TIERING=${_RING} \n";
                arcvar="${arcvar}Set: DI_DOCUMENTO=${_documento} \n";
		arcvar="${arcvar}Set: DI_DES=${_descripcion} \n";

                # agrego variable compuesta de demograficos
                sudo echo -e "$archivo$arcvar" > /var/spool/asterisk/tmp/${FILE}.call;

                sudo chown asterisk:asterisk /var/spool/asterisk/tmp/${FILE}.call;
		sudo chmod 777 /var/spool/asterisk/tmp/${FILE}.call;
                sudo mv /var/spool/asterisk/tmp/${FILE}.call /var/spool/asterisk/outgoing/		

                sed -i '1,1 d' /var/taller/data/robocall_${ID}.txt
		echo "[${DT}]:${ID} REGISTRO=${_idreg} Saco la llamada al numero: ${_telefono} \n" >> /var/taller/log/robocall_${ID}.log;
                # reseteo archivos y variables
		_idreg=""
		_telefono=""
		_nombre=""
		_documento=""
		_descripcion=""
                archivo=''
                arcvar=''

		echo "[${DT}]:${ID} (${dialer_nombre}) Posicion: $n de Canales: ${_CANALES} \n" >> /var/taller/log/robocall_${ID}.log;

		if [ $n == ${_CANALES} ]; then
			echo "[${DT}]: ${ID} (${dialer_nombre}) Nuevos canales: ${_CANALES} y velocidad: ${_VELOCIDAD} \n" >> /var/taller/log/robocall_${ID}.log;
			if [ ${_CANALES} != 0 ]; then
				echo "[$DT]: (${dialer_nombre}) me detengo y duermo por velocidad ${_VELOCIDAD} segundos A LOS CANALES: ${_CANALES} en simultaneo  \n" >> /var/taller/log/robocall_${ID}.log;
				n=0
				sleep ${_VELOCIDAD}
			fi
              fi
        done < /var/taller/data/robocall_${ID}.txt


        DT=`date '+%Y-%m-%d_%H:%M:%S_%N'`

        echo "[${DT}]: Barrido de Base (${dialer_nombre}) Finalizado : ${ID}. En estos momentos se cuentran los reintentos en proceso " >> /var/taller/log/robocall_${ID}.log

	#let "REMOVER=${VELOCIDAD}*2"
	sleep ${_VELOCIDAD}


        echo "[${DT}]: Finalizando Robocall :  ${ID} (${dialer_nombre})  " >> /var/taller/log/robocall_${ID}.log

exit
