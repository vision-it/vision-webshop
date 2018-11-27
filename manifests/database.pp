# Class: vision_webshop::database
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_webshop::database
#

class vision_webshop::database (

  String $mysql_database = $vision_webshop::mysql_database,
  String $mysql_password = $vision_webshop::mysql_password,
  String $mysql_user = $vision_webshop::mysql_user,
  String $mysql_host = $vision_webshop::mysql_host,
  String $mysql_root_password = $vision_webshop::mysql_root_password,
  Optional[String] $backup_password = $vision_webshop::backup_password

  ) {

  if !defined(Class['::vision_mysql::server']) {
    # no backups in staging environment
    if $::applicationtier == 'staging' {
      class { '::vision_mysql::server':
        root_password => $mysql_root_password,
      }
    } else {
      class { '::vision_mysql::server':
        root_password => $mysql_root_password,
        backup        => {
          databases => [$mysql_database],
          password  => $backup_password,
        }
      }
    }
  }


  ::mysql::db { $mysql_database:
    user     => $mysql_user,
    password => $mysql_password,
    host     => '%',
    grant    => [ 'SELECT', 'UPDATE', 'CREATE', 'INSERT', 'ALTER', 'DELETE', 'DROP' ],
    require  => Class['::vision_mysql::server'],
  }

}
