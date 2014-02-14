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


sshd::config{
	"PermitRootLogin": value => "no";
	"PasswordAuthentication": value => "no";
}

ssh_authorized_key { 'Muse':
	ensure	=> present,
	key	=> "AAAAB3NzaC1yc2EAAAABJQAAAIEAhRqqIip5pkJBAFEqPzJJePkUn5gU5wkowyY19FLHdbDiwu4KCJEjTPyyPIRl/NRa0vaYDrV3+8OkefXwzoKSt/GckdhvtVhm23EFGebWLEhseAqMKBPG+jJd0eq/u/Dy2lPqgXvWm/L2nwp3TRAnk5pBeA7uhffpVpIX/DHzf6c=",
	user	=> theinsomniac,
	type	=> ssh-rsa,
}

ssh_authorized_key { 'Emancipation':
	ensure	=> present,
	key	=> "AAAAB3NzaC1yc2EAAAABJQAAAIB8kuyAHljH1oO9gVXqKKFcj2Etelx0S3B7LRxpH2T9wIBeqynXBeWKoGAHuKCLYoBLEpvgp/cmm3YeZsOiWxMlkovy0Jpx24wdLNdKVs9cv/ANhx6WQBrLGksOcN8S++zVx3xmmM5DEkolKlg6AFr20HeQSUfSO5yl4vFY8ggtiQ=",
	user	=> theinsomniac,
	type	=> ssh-rsa,
}
ssh_authorized_key { 'Redemption':
	ensure	=> present,
	key	=> "AAAAB3NzaC1yc2EAAAABIwAAAQEAzv7RuFp1loiqkMjV6UkYVjXu6FQFHaXR8lMMksWBtIh7sNteFR47L5j3miTVuoJ4xSBx49dhrCEXpWB2bg0ZYT+bnYwkhpF2N+qJXkN8x4x4fhef0+z4jAjgKszRJBLwM259+yNk91jQKsUAiHr32gB4nH0YoYEDzgJQLQ3ttu8LGAR4pTyaayy3296JoEM5mY3MTKLsELnCccsEXzA8bmSARcQuIfrwGn3sGW4RfyW+GczmZ1d5TQzVHDiqbEWX62tzgBohS8ZVt8k7rUia66+NMLIgMMMfktRITLOJv1IMVM0yVRDMIlPYJZWOqoJjtwOtZJ1RiJZ2Vn6AdZDbBw=",
	user	=> theinsomniac,
	type	=> ssh-rsa,
}
#file { '/home/theinsomniac/.ssh/licensekey.dat': 
#	ensure => link,
#	target => '/opt/static/teamspeak/licensekey.dat'
#}

