# Class: ts3server::mysql
#
#   The ts3server mysql plugin settings.
#
# Parameters:
# * host (127.0.0.1)
#   The hostname or IP addresss of your MySQL server.
#
# * port (3306)
#   The TCP port of your MySQL server.
#  
# * username (root)
#   The username used to authenticate with your MySQL server.
#
# * password (<empty>)
#   The password used to authenticate with your MySQL server.
#
# * database (test)
#   The name of a database on your MySQL server. Note that this database must be created
#   before the TeamSpeak 3 Server is started.
#  
# * socket (<empty>)
#   The name of the Unix socket file to use, for connections made via a named pipe to a 
#   local server.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class ts3server::mysql (
  $database    = undef,
  $host        = 'localhost',
  $password    = undef,
  $port        = '3306',
  $socket      = undef,
  $username    = undef,
  $server_root = $ts3server::params::server_root,
) inherits ts3server::params {
  
  include ts3server

  case $::osfamily {
    'Debian': {
      $libmysqlclient15      = 'libmysqlclient15off_5.0.96-0ubuntu3_amd64.deb'
      $libmysqlclient15_repo = 'http://security.ubuntu.com/ubuntu/pool/main/m/mysql-dfsg-5.0'
      $provider              = 'dpkg'
    }
    'RedHat': {
      $libmysqlclient15      = 'libmysqlclient15-5.0.95-5.w5.x86_64.rpm'
      $libmysqlclient15_repo = 'http://repo.webtatic.com/yum/centos/5/x86_64'
      $provider              = 'yum'
    }
    Default: {
      fail("ts3db_mysql is not supported by this module for ${::osfamily}.")
    }
  }

  staging::file { $libmysqlclient15:
    source => "$libmysqlclient15_repo/$libmysqlclient15",
  }

  package { 'libmysqlclient.so.15':
    ensure   => installed,
    source   => $libmysqlclient15,
    provider => $provider,
    require  => Staging::File[$libmysqlclient15],
  }

  file { "${server_root}/mysql.ini":
    ensure  => file,
    content => template('ts3server/ts3db_mysql.ini.erb'),
    owner   => 'teamspeak',
    group   => 'teamspeak',
    notify  => Service['teamspeak'],
  }
}
