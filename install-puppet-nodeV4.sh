#!/bin/bash

if [ "$#" -ne 4 ]; then
	echo "./script -ipserver -servername -ipclient -client name"
	echo "Carefull with args, no parsing error !"
	echo "Carefull if you relaunch script, check /etc/hosts !"
	echo "Remember, you need root privilege, ofc !"
	exit 1
fi

#change hostname at /etc/conf.d/host
###Port 22 et 8140 necessaire a puppet.
#Un restart du demon ssh est necessaire.
iptables -A INPUT -p TCP --dport 22 -j ACCEPT
iptables -A OUTPUT -p TCP --dport 22 -j ACCEPT
iptables -A INPUT -p TCP --dport 8140 -j ACCEPT
iptables -A OUTPUT -p TCP --dport 8140 -j ACCEPT
/etc/init.d/sshd restart

###Ajoute dansle fichier /etc/hosts.Permet de set les noms.
#Un restart du demon hostname necessaire.
echo "$3 localhost localhost.$4 $4" >> /etc/hosts
echo "$1	$2	$2	$2" >> /etc/hosts
/etc/init.d/hostname restart

###Ajout du fichier de config USE flags nexylan (modifier).
echo "dev-lang/php    json simplexml hash pdo ctype pcre session unicode ftp gd xml dba pcre cli cgi expat zlib curl xmlrpc gmp sockets bzip2 zip xpm truetype ssl soap fpm xmlreader xmlwriter mysqli 
opcache gd
>=app-eselect/eselect-php-0.9.2 apache2
dev-db/mysql    latin1
net-ftp/proftpd         -mysql
net-misc/curl           ssl
net-analyzer/rrdtool    perl graph
dev-lang/python xml
net-dns/bind    -mysql -berkdb -postgres
app-admin/puppet augeas
net-analyzer/munin      http
=sys-apps/net-tools-1.60_p20120127084908 old-output
net-analyzer/zabbix agent
net-ftp/proftpd openssl exec
dev-vcs/subversion    -apache2
app-eselect/eselect-php    fpm
mail-mta/postfix    sasl
net-analyzer/icinga2 libressl -minimal mysql vim-syntax plugins -classicui console lto mail nano-syntax apache2
>=media-libs/gd-2.2.4 fontconfig
www-apps/icingaweb2 apache2 -ldap mysql -nginx -postgres
=dev-ruby/facter-3.6.1
# required by www-apps/icingaweb2-2.4.1::gentoo[apache2]
# required by www-apps/icingaweb2 (argument)
>=dev-lang/php-7.0.15 apache2 mysql
# required by dev-php/pecl-imagick-3.4.1::gentoo
# required by www-apps/icingaweb2-2.4.1::gentoo
# required by www-apps/icingaweb2 (argument)
>=media-gfx/imagemagick-6.9.7.4 -openmp
>=dev-lang/php-7.0.15 intl xslt" > /etc/portage/package.use/nexylan

###Ajout du fichier package.accept_keywords inexistant a la base, necessaire a la bonne installation de icinga-web (v1.14)
echo "# required by dev-php/PEAR-PEAR_PackageFileManager-1.7.2-r1::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/PEAR-PEAR_PackageFileManager2-1.0.4-r1 ~amd64
# required by dev-php/PEAR-PEAR_PackageFileManager2-1.0.4-r1::gentoo[-minimal]
# required by dev-php/PEAR-PEAR_PackageFileManager-1.7.2-r1::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/PEAR-PHP_CompatInfo-1.9.0 ~amd64
# required by dev-php/PEAR-PHP_CompatInfo-1.9.0::gentoo[-minimal]
# required by dev-php/PEAR-PEAR_PackageFileManager2-1.0.4-r1::gentoo[-minimal]
# required by dev-php/PEAR-PEAR_PackageFileManager-1.7.2-r1::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/PEAR-Console_Getargs-1.3.5 ~amd64
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/PEAR-PEAR_PackageFileManager-1.7.2-r1 ~amd64
# required by dev-php/PEAR-PEAR_PackageFileManager2-1.0.4-r1::gentoo
# required by dev-php/PEAR-PEAR_PackageFileManager-1.7.2-r1::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/PEAR-PEAR_PackageFileManager_Plugins-1.0.4-r1 ~amd64
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/phpDocumentor-2.8.2 ~amd64
# required by dev-php/symfony-filesystem-2.7.20::gentoo
# required by dev-php/symfony-config-2.8.15-r1::gentoo
# required by dev-php/symfony-dependency-injection-2.8.15::gentoo
# required by dev-php/phpdepend-2.3.2::gentoo
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/fedora-autoloader-0.2.1 ~amd64
# required by dev-php/phpdepend-2.3.2::gentoo
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/symfony-dependency-injection-2.8.15 ~amd64
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/phpmd-2.5.0 ~amd64
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/phing-2.16.0 ~amd64
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/phpdepend-2.3.2 ~amd64
# required by net-analyzer/icinga-web (argument)
=net-analyzer/icinga-web-1.14.0 ~amd64
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/simpletest-1.1.0 ~amd64
# required by dev-php/symfony-dependency-injection-2.8.15::gentoo
# required by dev-php/phpdepend-2.3.2::gentoo
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/symfony-yaml-2.1.0 ~amd64
# required by dev-php/phpdepend-2.3.2::gentoo
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/symfony-filesystem-2.7.20 ~amd64
# required by dev-php/phpdepend-2.3.2::gentoo
# required by dev-php/phpmd-2.5.0::gentoo
# required by dev-php/phing-2.16.0::gentoo[-minimal]
# required by net-analyzer/icinga-web-1.14.0::gentoo
# required by net-analyzer/icinga-web (argument)
=dev-php/symfony-config-2.8.15-r1 ~amd64" > /etc/portage/package.accept_keywords

###Install de puppet.
emerge --sync
#emerge =dev-ruby/facter-3.6.1
#For some unkown reason facter 3.6.2 have conflict. 3.6.1 solve the problem if reboot, but on docker facter-3.6.3 works fine
emerge facter
emerge puppet
rc-update add sshd default

###Creation des dossier et ss dossier necessaire.
/bin/mkdir /etc/puppetlabs/code
/bin/mkdir /etc/puppetlabs/code/environments/
/bin/mkdir /etc/puppetlabs/code/environments/production/
/bin/mkdir /etc/puppetlabs/code/environments/production/manifests/
/bin/mkdir /opt/puppetlabs/
/bin/mkdir /opt/puppetlabs/puppet/
/bin/mkdir /opt/puppetlabs/puppet/modules/
#Creation du lien symbolique
cd /etc/puppetlabs/code/environments/production/
/bin/ln -s /opt/puppetlabs/puppet/modules /etc/puppetlabs/code/environments/production/modules

###Creation du fichier de conf
cd /etc/puppetlabs/puppet/
puppet agent --genconfig > /etc/puppetlabs/puppet/puppet.conf
#Si error facterlib, check version (3.6.1 stable), si persiste, reboot machine
/etc/init.d/puppet restart
rc-update add puppet default

###Install d'un module  puppet, obligatoire sous Gentoo car sinon ne trouve pas de path
#pour les future modules installer.
#/!\Necessaire pour l'execution de fonction dans le init.pp plus tard
puppet module install puppetlabs/stdlib

###Certificat
puppet agent -t
#en attente d'etre accepter par le serveur --> puppet cert list ; puppet cert sign [nomducertificat]
#/!\ /etc/init.d/puppetmaster DOIT etre lancer pour la signature du certif ! Bien verifier que puppetmaster est lancer/!\
#Erreur de certificats:
#http://blog.adityapatawari.com/2012/02/puppet-and-common-errors.html
#

echo "/!\ Il faut set le serveur apache une fois le module puppet php installer!"
echo "/!\ Rajouter l'option [-D PHP] dans /etc/conf.d/apache2"

###EOF###
