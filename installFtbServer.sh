#!/bin/bash

if [ $(id -u) -eq 0 ]; then
	username = "minecraft"
	read -s -p "Gebe ein passwort ein : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt(ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username"
		[ $? -eq 0 ] && echo "User has been added to system" || echo "Failed to add user"
else
	echo "Only root can run this install script"
	exit 2
fi
cd /home/mincraft
mkdir server
cd server
wget https://media.forgecdn.net/files/2690/320/FTB+Presents+Direwolf20+1.12-1.12.2-2.5.0-Server.zip
