#PWD icinga web --> icingaweb_admin pwd= needroot
# You must be root, ofc!

class lamp {

	Package {ensure => 'installed'}

	package {'apache':}
	service { 'apache2':
			ensure => running,}

	package {'dev-db/mysql':}
	exec {'emerge':
		command => '/usr/bin/emerge --config =dev-db/mysql-5.6.35'}
	service { 'mysql':
			ensure => running,}

	package {'gd':}

	package {'dev-lang/php':}
	service { 'php-fpm':
			ensure => running,}

file { '/etc/php/apache2-php7.0/php.ini':
  ensure => present,
}->
file_line { '; date.timezone =':
  path => '/etc/php/apache2-php7.0/php.ini',
  line => 'date.timezone = Europe/Paris',
}
#http://stackoverflow.com/questions/10800199/how-to-set-config-value-in-php-ini-with-puppet

	package {'icinga2':}
	service {'icinga2':
			ensure => running,}

	package { 'www-apps/icingaweb2':}

#editer le fichier hosts.conf et decommenter les lignes. decommenter ligne pour icingaweb2 
#(/etc/icinga2/conf.d/hosts.conf)
file { '/etc/icinga2/conf.d/hosts.conf':
  ensure => present,
}->
file_line { '//vars.http_vhosts':
  path => '/etc/icinga2/conf.d/hosts.conf',
  line => 'vars.http_vhosts["Icinga Web 2"] = {http_uri = "/icingaweb2"}',
}


	mysql::db {'icinga2':
	user => 'icinga2',
	password => 'changeme',
	host => 'localhost',
	grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE VIEW','INDEX','EXECUTE'],
	sql => '/usr/share/icinga2-ido-mysql/schema/mysql.sql',}

	mysql::db {'icingaweb2':
	user => 'icingaweb2',
	password => 'changeme',

	host => 'localhost',
	grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE VIEW','INDEX','EXECUTE'],
	sql => '/usr/share/icingaweb2/etc/schema/mysql.schema.sql',}

 ## utiliser la command exec ?
#icinga2 feature enable ido-mysql livestatus perfdata statusdata command
###remplacer /etc/icinga2/features-available/ido-mysql.conf par:
###
#library "db_ido_mysql"
#
#object IdoMysqlConnection "ido-mysql" {
#  user = "icinga2"
#  password = "changeme"

#  host = "localhost"
#  database = "icinga2"
#}
###
#il faut restart;
#/etc/init.d/icinga2 restart
###
#set du vhost
#cp /usr/share/icingaweb2/packages/files/apache/icingaweb2.conf  /etc/apache2/modules.d/
#reload apache2
#/etc/init.d/apache2 reload
###
### localhost/icingaweb2/setup -> token:
#mkdir -m 2770 /etc/icingaweb2;
#chgrp icingaweb2 /etc/icingaweb2;
#chmod 777 /etc/icingaweb2;
#head -c 12 /dev/urandom | base64 | tee /etc/icingaweb2/setup.token; <-- token saffiche
#chmod 777 /etc/icingaweb2/setup.token;
###
	file { '/var/www/localhost/htdocs/info.php':
						ensure => file,
						content => '<?php  phpinfo(); ?>',
						require => Package['apache'],}
}

#ajouter rc-update php-fpm default
#ajouter rc-update apache2 default
#ajouter rc-update mysql default
#ajouter rc-update puppet default
#ajouter rc-update icinga2 default
#ajouter rc-update ido2db default
