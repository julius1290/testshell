#!/bin/bash

sudo apt update && apt install --assume-yes git wget curl
if [ $(id -u) -eq 0 ]; then
        read -p "username : " username
        read -s -p "Gebe ein passwort ein : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                pass=$(perl -e 'print crypt(ARGV[0], "password")' $password)
                useradd -m -p "$pass" "$username"
                [ $? -eq 0 ] && echo "User has been added to system" || echo "Failed to add user"
        fi
else
        echo "Only root can run this install script"
        exit 2
fi
cd /home/$username
mkdir server
cd server
wget https://media.forgecdn.net/files/2690/320/FTB+Presents+Direwolf20+1.12-1.12.2-2.5.0-Server.zip
sudo apt update && apt install unzip
unzip -a FTB+Presents+Direwolf20+1.12-1.12.2-2.5.0-Server.zip
rm FTB+Presents+Direwolf20+1.12-1.12.2-2.5.0-Server.zip
sudo apt update && apt install --assume-yes tmux
sudo apt update && apt install --assume-yes apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt update && apt install --assume-yes adoptopenjdk-8-hotspot
java -version
touch eula.txt
echo 'eula=true' > eula.txt
cat eula.txt
chmod +x ServerStart.sh
tmux new-session -d -s minecraft './ServerStart.sh'
