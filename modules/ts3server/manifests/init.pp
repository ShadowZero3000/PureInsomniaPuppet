# Class: ts3server
#
#   The ts3server.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class ts3server (
  $daemon = true,
  $architecture          = $ts3server::params::architecture,
  $clear_database        = $ts3server::params::clear_database,
  $dbplugin              = $ts3server::params::dbplugin,
  $dbsqlcreatepath       = $ts3server::params::dbsqlcreatepath,
  $default_virtualserver = $ts3server::params::default_virtualserver,
  $filetransfer_ip       = $ts3server::params::filetransfer_ip,
  $filetransfer_port     = $ts3server::params::filetransfer_port,
  $group                 = $ts3server::params::group,
  $inifile               = $ts3server::params::inifile,
  $keyfile               = $ts3server::params::keyfile,
  $logpath               = $ts3server::params::logpath,
  $machine_id            = $ts3server::params::machine_id,
  $port                  = $ts3server::params::port,
  $query_ip              = $ts3server::params::query_ip,
  $query_port            = $ts3server::params::query_port,
  $server_root           = $ts3server::params::server_root,
  $user                  = $ts3server::params::user,
  $version               = $ts3server::params::version,
  $voice_ip              = $ts3server::params::voice_ip,
  $ts3server_package     = $ts3server::params::ts3server_package,
  $ts3server_package_url = $ts3server::params::ts3server_package_url,
  $licensepath		 = $ts3server::params::licensepath,
)  inherits ts3server::params {

  class { 'staging':
    path  => '/tmp/staging',
  }

  staging::file { $ts3server_package:
    source => $ts3server_package_url,
  }

  if ! defined(Package['screen']) {
    package { 'screen':
      ensure => installed,
    }
  }

  staging::extract { $ts3server_package:
    target  => '/opt',
    creates => $server_root,
    require => Staging::File[$ts3server_package],
  }

  file { $server_root:
    ensure  => directory,
    recurse => true,
    owner   => $user,
    group   => $group,
    require => Staging::Extract[$ts3server_package],
  }

  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    home    => $server_root,
    gid     => $group,
    require => Group[$group],
  }

  file { "$server_root/ts3server.ini":
    ensure  => file,
    content => template('ts3server/ts3server.ini.erb'),
    owner   => $user,
    group   => $group,
    require => File[$server_root],
    notify  => Service['teamspeak'],
  }

  if $keyfile != undef {
    file { $server_root:
      ensure => file,
      source => $keyfile,
    }
  }

  file { '/etc/init.d/teamspeak':
    ensure  => file,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content  => template('ts3server/teamspeak.erb'),
  }

  service { 'teamspeak':
    enable  => true,
    ensure  => running,
    require => File['/etc/init.d/teamspeak'],
  }
}
