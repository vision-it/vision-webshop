# Class: vision_webshop
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_webshop
#

class vision_webshop (

  String $backup_password,
  String $mysql_database,
  String $mysql_password,
  String $mysql_root_password,
  String $mysql_user,
  String $mysql_host = $::fqdn,

) {

  contain ::vision_jenkins::user
  contain ::vision_docker
  contain vision_webshop::docker

  vision_shipit::inotify { 'webshop_tag':
    group   => 'jenkins',
    require => Class['::vision_jenkins::user'],
  }

  class { '::vision_mysql::server':
    root_password => $mysql_root_password,
    backup        => {
      databases => [$mysql_database],
      password  => $backup_password,
    }
  }
  -> ::mysql::db { $mysql_database:
    user     => $mysql_user,
    password => $mysql_password,
    host     => '%',
    grant    => [ 'SELECT', 'UPDATE', 'CREATE', 'INSERT', 'ALTER', 'DELETE', 'DROP' ],
  }

  file { ['/data', '/data/logs', '/data/resources']:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

  Class['::vision_docker']
  -> Class['::vision_webshop::docker']

}
