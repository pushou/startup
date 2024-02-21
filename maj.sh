#! /bin/bash

is_centos() {
[[ $(lsb_release -d) =~ "CentOS" ]]
return $?
}
is_debian() {
[[ $(lsb_release -d) =~ "Debian" ]]
return $?
}
is_ubuntu() {
[[ $(lsb_release -d) =~ "Ubuntu" ]]
return $?
}


figlet "IUT BEZIERS"
#cat /home/bin/dockerlogin | docker login --username iutbrt --password-stdin registry.iutbeziers.fr
if is_centos; then
	cp -f /home/bin/bashrc.centos /root/.bashrc
else
	cp -f /home/bin/bashrc /root/.bashrc
        docker logout
        docker logout registry.iutbeziers.fr
fi
cp -f /home/bin/profile /root/.profile
MACHINE_TYPE=$(uname -m)
if [ ${MACHINE_TYPE} == 'x86_64' ];then
   echo -e "\nMaj des containers DEBIAN IUT\n"
   if is_centos; then
        podman pull registry.iutbeziers.fr/debianiut:latest
   else
	docker pull registry.iutbeziers.fr/debianiut:latest
   fi
#  podman pull registry.iutbeziers.fr/debianiut:latest
#   FICH=/usr/local/bin/docker-compose
#   if [ ! -f $FICH ];then
#       curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
#   fi
   timedatectl set-local-rtc 1 --adjust-system-clock
   
fi
# disable du swap pour kubernetes
if is_ubuntu; then
 sudo swapoff -a
 sudo timedatectl set-timezone "Europe/Paris"
 sudo timedatectl set-ntp true
fi

chown root:root /root/.bashrc
echo -e "\nDeux utilisateurs sont créés:\n user root password root\n user student password student\n"
echo -e "\nsudo est activé sans mot de passe\n"
echo -e "\nListe des ip de la VM:\n"
ip addr |grep --color=always '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
echo -e "\nConnectez-vous en ssh depuis votre machine physique vous gagnerez du temps pour les copier-coller ..."
