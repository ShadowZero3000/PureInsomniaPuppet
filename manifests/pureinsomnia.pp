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
apache::module { 'proxy':}
apache::module { 'vhost_alias':}

file {'pureinsomnia.com':
  path		=> '/etc/apache2/sites-available/pureinsomnia.com.conf',
  ensure	=> file,
  source	=> 'puppet:///modules/pureinsomnia/pureinsomnia.com.conf',
  owner		=> root,
  mode		=> 0644,
}
file {'pureinsomnia.com-link':
  path		=> '/etc/apache2/sites-enabled/00-pureinsomnia.com.conf',
  ensure	=> link,
  target	=> '../sites-available/pureinsomnia.com.conf',
}

class { 'ts3server':
	dbsqlcreatepath => 'create_sqlite',
	version => '3.0.10.3',
	licensepath => '/opt/static/teamspeak/',
}

user { 'etherpad':
	name	=> etherpad,
	ensure	=> present,
}

file {'etherpadInit':
  path		=> '/etc/init.d/etherpad',
  ensure	=> file,
  source	=> 'puppet:///modules/pureinsomnia/etherpad',
  owner		=> root,
  mode		=> 0744,
}

service { 'etherpad':
	name	=> etherpad,
	ensure	=> running,
	enable	=> true,
	path	=> '/etc/init.d/',
}


file {'svnserveInit':
  path		=> '/etc/init.d/svnserve',
  ensure	=> file,
  source	=> 'puppet:///modules/pureinsomnia/svnserve',
  owner		=> root,
  mode		=> 0744,
}

service { 'svnserve':
	name	=> svnserve,
	ensure	=> running,
	enable	=> true,
	path	=> '/etc/init.d/',
}

#file { '/home/theinsomniac/.ssh/licensekey.dat': 
#	ensure => link,
#	target => '/opt/static/teamspeak/licensekey.dat'
#}
