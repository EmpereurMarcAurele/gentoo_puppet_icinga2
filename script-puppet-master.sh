### manifests/init.pp
node default {
	include gamp
	include install_iiw2
	include install_set_mysql
	include set_iiw2
}

### gamp/manifests/init.pp
class	gamp {

	package {'apache':}
	service { 'apache2':
		ensure => running,}

	package {'dev-lang/php':}
	service { 'php-fpm':
		ensure => running,}

	file { '/etc/php/apache2-php7.0/php.ini':
		ensure => present,
	}->
	file_line { '; date.timezone =':
		path => '/etc/php/apache2-php7.0/php.ini',
		line => 'date.timezone = Europe/Paris',}

	file { '/var/www/localhost/htdocs/info.php':
					ensure => file,
					content => '<?php  phpinfo(); ?>',
					require => Package['apache'],}

	exec {'mysql':
		command => 'puppet module install puppetlabs-mysql',
		path => ['/usr/bin', '/bin'],}
	exec {'icinga2':
		command => 'puppet module install --ignore-dependencies icinga-icinga2 --version 1.2.1',
		path => ['/usr/bin', '/bin'],}
	exec {'icingaweb2':
		command => 'puppet module install --ignore-dependencies icinga-icingaweb2 --version 1.0.6',
		path => ['/usr/bin', '/bin'],}
}

class	install_iiw2 {
	package {'icinga2':}
	service {'icinga2':
			ensure => running,}

	package { 'www-apps/icingaweb2':}
}

class	install_set_mysql {
	package {'dev-db/mysql':}
        exec {'emerge':
                command => '/usr/bin/emerge --config =dev-db/mysql-5.6.35'}
        service { 'mysql':
                        ensure => running,}

#        mysql::db {'icinga2':
#        user => 'icinga2',
#        password => 'changeme',
#        host => 'localhost',
#        grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE VIEW','INDEX','EXECUTE'],
#        sql => '/usr/share/icinga2-ido-mysql/schema/mysql.sql',}

#        mysql::db {'icingaweb2':
#        user => 'icingaweb2',
#        password => 'changeme',
#        host => 'localhost',
#        grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE VIEW','INDEX','EXECUTE'],
#        sql => '/usr/share/icingaweb2/etc/schema/mysql.schema.sql',}
}

class	set_iiw2 {
##
	exec {'sed Icinga2conf1':
		command => 'sed "s_//_ _g" /etc/icinga2/conf.d/hosts.conf > /etc/icinga2/conf.d/hosts.conf.icingaweb2',
		path => ['/usr/bin', '/bin'],}
	exec {'sed Icinga2conf2':
		command => 'mv /etc/icinga2/conf.d/hosts.conf.icingaweb2 /etc/icinga2/conf.d/hosts.conf',
		path => ['/usr/bin', '/bin'],}
##
	exec {'echo1':
		command => 'echo "library "\"db_ido_mysql"\"" > /etc/icinga2/features-available/ido-mysql.conf',
		path => ['/usr/bin', '/bin'],}
	exec {'echo2':
		command => 'echo "object IdoMysqlConnection "\"ido-mysql"\"" { >> /etc/icinga2/features-available/ido-mysql.conf',
		path =>	['/usr/bin', '/bin'],}
	exec {'echo3':
		command => 'echo "user = "\"icinga2"\"" >> /etc/icinga2/features-available/ido-mysql.conf',
		path =>	['/usr/bin', '/bin'],}
	exec {'echo4':
		command => 'echo "password = "\"changeme"\"" >> /etc/icinga2/features-available/ido-mysql.conf',
		path =>	['/usr/bin', '/bin'],}
	exec {'echo5':
		command => 'echo "host = "\"localhost"\"" >> /etc/icinga2/features-available/ido-mysql.conf',
		path =>	['/usr/bin', '/bin'],}
	exec {'echo6':
		command => 'echo "database = "\"icinga2"\""} >> /etc/icinga2/features-available/ido-mysql.conf',
		path =>	['/usr/bin', '/bin'],}
##
	exec {'icinga2 restart':
		command => '/etc/init.d/icinga2 restart',
		path => ['/usr/bin', '/bin'],}
	exec {'cp icingaweb2.conf':
		command => 'cp /usr/share/icingaweb2/packages/files/apache/icingaweb2.conf  /etc/apache2/modules.d/',
		path => ['/usr/bin', '/bin'],}
	exec {'apache2 reload':
		command => '/etc/init.d/apache2 reload',
		path => ['/usr/bin', '/bin'],}
	exec {'mkdir icingaweb2':
		command => 'mkdir -m 2770 /etc/icingaweb2',
		path => ['/usr/bin', '/bin'],}
	exec {'chgrp icingaweb folder':
		command => 'chgrp icingaweb2 /etc/icingaweb2',
		path => ['/usr/bin', '/bin'],}
	exec {'chmod icingaweb2 folder':
		command => 'chmod 777 /etc/icingaweb2',
		path => ['/usr/bin', '/bin'],}
	exec {'cat token':
		command => 'head -c 12 /dev/urandom | base64 | tee /etc/icingaweb2/setup.token',
		path => ['/usr/bin', '/bin'],}
	exec {'chmod token for setup':
		command => 'chmod 777 /etc/icingaweb2/setup.token',
		path => ['/usr/bin', '/bin'],}
}
