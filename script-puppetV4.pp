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
		command => 'puppet module install --ignore-dependencies icinga-icinga2 --version 
1.2.1',
		path => ['/usr/bin', '/bin'],}
	exec {'icingaweb2':
		command => 'puppet module install --ignore-dependencies icinga-icingaweb2 
--version 1.0.6',
		path => ['/usr/bin', '/bin'],}
	
}

class	install_miiw2 {
	class {'mysql::server':}
##<--/!\ modify HERE icinga2 files for Gentoo !!!
## + exec(icinga2 deature enable ido-mysql) idomysql set cause errors
	class {'icinga2':
		features => ['idomysql','livestatus','perfdata','statusdata','command'],}

	package {'www-apps/icingaweb2':}
}

class	set_mysql {

	class mysql::db {'icinga2':
		user => 'icinga2',
		password => 'changeme',
		host => 'localhost',
		grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE 
VIEW','INDEX','EXECUTE'],
		sql => '/usr/share/icinga2-ido-mysql/schema/mysql.sql',}

	class mysql::db {'icingaweb2':
		user => 'icingaweb2',
		password => 'changeme',
		host => 'localhost',
		grant => ['SELECT','INSERT','UPDATE','DELETE','DROP','CREATE 
VIEW','INDEX','EXECUTE'],
		sql => '/usr/share/icingaweb2/etc/schema/mysql.schema.sql',}
}

class	set_iiw2 {

	file { '/etc/icinga2/conf.d/hosts.conf':
		ensure => present,
	}->
	file_line { '//vars.http_vhosts':
		path => '/etc/icinga2/conf.d/hosts.conf',
		line => 'vars.http_vhosts["Icinga Web 2"] = {http_uri = "/icingaweb2"}',}

}

