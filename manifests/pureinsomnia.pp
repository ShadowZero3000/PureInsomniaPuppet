package {'php5':
  ensure => present,  
  before => File['/etc/php5/apache2/php.ini'],
}

file {'/etc/php5/apache2/php.ini':
  ensure => file,
}

package {'mysql-server':
  ensure => 'present',
}

service {'mysql':
  ensure => running,
  enable => true,
  require => Package['mysql-server'],
}
include ufw
ufw::allow { "allow-global-tcp":
	port => "22,80,443",
}
ufw::allow { "allow-global-udp":
	port => "53",
	proto => "udp",
}
ufw::allow { "teamspeak-tcp":
	port => "9987,9988",
	proto => "tcp",
}
ufw::allow { "teamspeak-udp":
	port => "9987,9988",
	proto => "udp",
}

class { 'apache':
}
apache::vhost { 'pureinsomnia.com':
	docroot 	=> '/var/www/pureinsomnia.com',
	server_name	=> 'pureinsomnia.com',
	priority	=> '',
	template	=> 'apache/virtualhost/vhost.conf.erb',
}
/*
apache::vhost { 'pad.pureinsomnia.com':
    vhost_name => 'pad.pureinsomnia.com',
    port       => '80',
    docroot          => '/var/www/pad.pureinsomnia.com',
	proxy_pass => [
		{'path' => '/', 'url' => 'http://localhost:9001/' }
	],
}
apache::vhost { '*.pureinsomnia.com':
    vhost_name => '*',
    port       => '80',
    virtual_docroot => '/var/www/%-2+',
    docroot          => '/var/www',
    serveraliases    => ['*.pureinsomnia.com',],
	directories => [{ path => '/var/www/phpmyadmin.pureinsomnia.com','provider'=>'files','deny'=>'from all','allow'=>'from localhost','order'=>'deny,allow'}],
}
apache::vhost { '*.digiwireit.com':
    vhost_name => '*',
    port       => '80',
    virtual_docroot => '/var/www/%-2+',
    docroot          => '/var/www',
    serveraliases    => ['*.digiwireit.com',],
}
apache::vhost { '*.coloradorollerderby.org':
    vhost_name => '*',
    port       => '80',
    virtual_docroot => '/var/www/%-2+',
    docroot          => '/var/www',
    serveraliases    => ['*.coloradorollerderby.org',],
}
apache::vhost { 'phpmyadmin.pureinsomnia.com':
    docroot     => '/var/www/phpmyadmin',
    directories => [
		{ path => '~ (\.swp|\.bak|~)$', 'provider' => 'files', 'deny' => 'from all' },
    ],
}
*/
class { 'ts3server':
	dbsqlcreatepath => 'create_sqlite',
	version => '3.0.10.3',
	licensepath => '/opt/static/teamspeak/licensekey.dat',
}


#file { '/home/theinsomniac/.ssh/licensekey.dat': 
#	ensure => link,
#	target => '/opt/static/teamspeak/licensekey.dat'
#}
