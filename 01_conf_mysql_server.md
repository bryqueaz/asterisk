# Proceso de configuracion manual de MySQL 8

Conectar al gestor de la base de datos

* `sudo mysql`

```
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 65
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```
Cambiar el password para el usuario root en la terminal/cosola de MySQL

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'mypasss11122332';
quit

```

Configurar la opciones de seguridad basicas del gestor de base de datos MySQL 8

* `sudo mysql_secure_installation`

Configurar repo mysql-apt-config_0.8.12
* `cd /usr/src/asterisk-certified-16.8-cert14/`
* `sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb`
* `sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb`
* `sudo apt-get update`
* `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29`
* `sudo apt install -f mysql-client=8.0* mysql-community-server=8.0* mysql-server=8.0*`
* `sudo apt-get install unixodbc`

Configurar MySQL connector odbc
* `cd /usr/src/asterisk-certified-16.8-cert14/`
* `sudo wget https://downloads.mysql.com/archives/get/p/10/file/mysql-connector-odbc-8.0.17-linux-ubuntu19.04-x86-64bit.tar.gz`
* `sudo gunzip mysql-connector-odbc-8.0.17-linux-ubuntu19.04-x86-64bit.tar.gz`
* `sudo tar xvf mysql-connector-odbc-8.0.17-linux-ubuntu19.04-x86-64bit.tar`
* `cd /usr/src/asterisk-certified-16.8-cert14/mysql-connector-odbc-8.0.17-linux-ubuntu19.04-x86-64bit`
* `sudo cp bin/* /usr/local/bin`
* `sudo cp lib/* /usr/local/lib`
* `sudo myodbc-installer -a -d -n "MySQL ODBC 8.0 Driver" -t "Driver=/usr/local/lib/libmyodbc8w.so"`
* `odbcinst -j`
* Verificar que existan los files: `ls -lah /etc/odbc.ini  /etc/odbcinst.ini`
* Verificar que existan: `sudo find /usr -iname "*libmyodbc*`

Configuracion de ODBC
* Editar el siguiente file `sudo vim /etc/odbcinst.ini`
```[MySQL ODBC 8.0 Driver]
Description = ODBC for MySQL
Driver = /usr/local/lib/libmyodbc8w.so
Setup = /usr/local/lib/libmyodbc8S.so
FileUsage = 1
```
* `sudo odbcinst -i -d -f /etc/odbcinst.ini`
* Editar el siguiente file `sudo vim /etc/odbc.ini`
```
[asterisk-mysql]
Description = MySQL connection to 'asterisk' database
Driver = MySQL
Database = asterisk
Server = localhost
UserName = root
Password = 'mypasss11122332'
Port = 3306
Socket = /var/run/mysqld/mysqld.sock
```

Configuracion de bind-address para MySQL 8
* Editar el siguiente file `sudo vim  /etc/mysql/mysql.conf.d/mysqld.cnf`
```
[mysqld]
bind-address    = 0.0.0.0
```
* `sudo systemctl restart mysql.service`

Crear base de datos y tablas para asterisk

Se debe realizar la conexion al gestor de la base de datos con el usuario root y el ingreso con el password que se definio anteriormente y ejecutar las siguientes instrucciones.

```
ubuntu@asterisk:~$  mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 66
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```
* `create database asterisk;`
* `CREATE USER 'asterisk'@'localhost' IDENTIFIED BY 'mypasss11122332';`
* `GRANT ALL PRIVILEGES ON *.* TO 'asterisk'@'localhost';`
* `use asterisk;`
```
drop table if exists cdr;
CREATE TABLE cdr ( 
    id int(11) AUTO_INCREMENT,
        calldate datetime NOT NULL, 
        clid varchar(80) NOT NULL default '', 
        src varchar(80) NOT NULL default '', 
        dst varchar(80) NOT NULL default '', 
        dcontext varchar(80) NOT NULL default '', 
        channel varchar(80) NOT NULL default '', 
        dstchannel varchar(80) NOT NULL default '', 
        lastapp varchar(80) NOT NULL default '', 
        lastdata varchar(80) NOT NULL default '', 
        duration int(11) NOT NULL default '0', 
        billsec int(11) NOT NULL default '0', 
        disposition varchar(45) NOT NULL default '', 
        amaflags int(11) NOT NULL default '0', 
        accountcode varchar(20) NOT NULL default '', 
        uniqueid varchar(32) NOT NULL default '', 
        userfield varchar(255) NOT NULL default '',
    PRIMARY KEY (id)
);
```
* Probar la conexion con de odbc con isql: `sudo isql -v asterisk-mysql`

```
+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> quit

```














