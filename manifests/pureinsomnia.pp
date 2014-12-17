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
apache::module { 'ssl':}
apache::module { 'proxy':}
apache::module { 'vhost_alias':}

file {'pureinsomnia.com':
  path		=> '/etc/apache2/sites-available/pureinsomnia.com.conf',
  ensure	=> file,
  source	=> 'puppet:///modules/pureinsomnia/pureinsomnia.com.conf',
  owner		=> root,
  mode		=> 0644,
  require	=> Class['apache'],
}
file {'pureinsomnia.com-link':
  path		=> '/etc/apache2/sites-enabled/00-pureinsomnia.com.conf',
  ensure	=> link,
  target	=> '../sites-available/pureinsomnia.com.conf',
  require	=> Class['apache'],
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
	key	=> "AAAAB3NzaC1yc2EAAAABJQAAAIB8kuyAHljH1oO9gVXqKKFcj2Etelx0S3B7LRxpH2T9wIBeqynXBeWKoGAHuKCLYoBLEpvgp/cmm3YeZsOiWxMlkovy0Jpx24wdLNdKVs9cv/ANhx6WQBrLGksOcN8S++zVx3xmmM5DEkolKlg6AFr20HeQSUfSO5yl4vFY8ggtiQ==",
	user	=> theinsomniac,
	type	=> ssh-rsa,
}
ssh_authorized_key { 'Redemption':
	ensure	=> present,
	key	=> "AAAAB3NzaC1yc2EAAAABIwAAAQEAzv7RuFp1loiqkMjV6UkYVjXu6FQFHaXR8lMMksWBtIh7sNteFR47L5j3miTVuoJ4xSBx49dhrCEXpWB2bg0ZYT+bnYwkhpF2N+qJXkN8x4x4fhef0+z4jAjgKszRJBLwM259+yNk91jQKsUAiHr32gB4nH0YoYEDzgJQLQ3ttu8LGAR4pTyaayy3296JoEM5mY3MTKLsELnCccsEXzA8bmSARcQuIfrwGn3sGW4RfyW+GczmZ1d5TQzVHDiqbEWX62tzgBohS8ZVt8k7rUia66+NMLIgMMMfktRITLOJv1IMVM0yVRDMIlPYJZWOqoJjtwOtZJ1RiJZ2Vn6AdZDbBw==",
	user	=> theinsomniac,
	type	=> ssh-rsa,
}

class defaults {
	class { 'duplicity::params':
		bucket	=> 'raven_backup',
	dest_id => hiera("dest_id"),
	dest_key => hiera("dest_key"),
		remove_older_than => '2M',
		pubkey_id => '63452547',
		folder	=> 'raven.pureinsomnia.com',
	}
}

include defaults

duplicity { 'opt_backup':
	directory	=> '/opt/backup',
	pre_command	=> '/opt/backup/establishLinks.sh',
}
duplicity { 'sql_backup':
	pre_command	=> '/opt/sql_backup/prep.sh',
	directory	=> '/opt/sql_backup',
}


#file { '/home/theinsomniac/.ssh/licensekey.dat': 
#	ensure => link,
#	target => '/opt/static/teamspeak/licensekey.dat'
#}

apt::key { 'owncloud':
  key        => 'BA684223',
  key_source => 'http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_13.10/Release.key',
}
apt::source { 'owncloud_source':
	location => "http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_13.10/",
	repos => "/",
	release => "",
	before => Package['owncloud'],
	require => Apt::Key['owncloud'],
}
package{'owncloud':
	ensure=> 'installed',
}
ssh_authorized_key { 'Pearson':
	ensure	=> present,
	user	=> theinsomniac,
	type	=> ssh-rsa,
	key	=> "AAAAB3NzaC1yc2EAAAADAQABAAABAQDv2kEP9C2wqU/FAn0p1DsVvUqQ5tNb2Xz8UyAQzP1smq1R93bozfMY92Tna4a16xoGqi/zPfw09eHf4xAtGf6nIBRzRboXCLy9Mlaclg62Q0f28MWlFvaD5aov1K/Ywiel7etMWLryGzEnc43bexw298JVKPCb5LkmZq607TMC4gQHK4TsDBswTSFRIV0QspLRNW348dzUAo7rGQmbZ3vnp23J5LTWzeaDdYguc2kkbL2jZC57/Gsnpcv2k+m9vV1pcA+u31sL1eyER47NHONcZqXhjyfH7kSOEOxRSjKNERCDio0/bBpveF0XfW6q5ZAPlW7Fwci0mFQRiaQlK03p"
}
