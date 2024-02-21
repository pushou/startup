#! /bin/bash
# histexpand nécessaire pour le rappel de la commande qui est désactivé (voir !!) et pipefail sortie dès première erreur 
set -u -o history -o histexpand -o pipefail

# trap error
function print_error {
    read line file <<<$(caller)
    echo "Erreur à la ligne $line du fichier $file:" >&2
    sed "${line}q;d" "$file" >&2
}
trap print_error ERR


# wait de la résolution dns de registry pré-requis au bon déroulement du script
resolvectl query registry.iutbeziers.fr  >/dev/null 2>&1 || echo "erreur resolution dns" 

BINDIR='/home/bin'
REPOSOURCE='https://github.com/pushou/startup.git'


# On fait du git et c'est nécessaire
git config --global http.sslverify false
git config --global merge.autostash true
git config --global user.name "automation jmp"
git config --global user.email vm-automation@umontpellier.fr
git config --global pull.ff only
export GIT_SSL_NO_VERIFY=true

cd $BINDIR
git --git-dir=$BINDIR/.git --work-tree=$BINDIR pull $REPOSOURCE &>/dev/null  
chmod +x $BINDIR/maj.sh
# maj des containers en mode détaché
chown root:root /root/.bashrc
echo -e "\nDeux utilisateurs sont créés:\n user root password root\n user student password student\n"
echo -e "\nsudo est activé sans mot de passe\n"
echo -e "\nListe des ip de la VM:\n"
ip addr |grep --color=always '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
echo -e "\nConnectez-vous en ssh depuis votre machine physique vous gagnerez du temps pour les copier-coller ..."
nohup $BINDIR/maj.sh  >/dev/null 2>&1 &

