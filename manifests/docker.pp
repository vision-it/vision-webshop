# Class: vision_webshop::docker
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_webshop::docker
#

class vision_webshop::docker (

  String $mysql_database  = $vision_webshop::mysql_database,
  String $mysql_password  = $vision_webshop::mysql_password,
  String $mysql_user      = $vision_webshop::mysql_user,
  String $mysql_host      = $vision_webshop::mysql_host,

) {

  contain ::vision_docker

  ::docker::image { 'webshop':
    ensure    => present,
    image     => 'vision.fraunhofer.de/webshop',
    image_tag => 'master',
  }

  ::docker::run { 'webshop':
    image   => 'vision.fraunhofer.de/webshop:master',
    env     => [
      "DB_HOST=${mysql_host}",
      "DB_DATABASE=${mysql_database}",
      "DB_USERNAME=${mysql_user}",
      "DB_PASSWORD=${mysql_password}",
    ],
    ports   => [ '80:80' ],
    volumes => [
      '/data/resources:/var/www/html/resources',
      '/data/logs:/var/www/html/logs'
    ]
  }

}
