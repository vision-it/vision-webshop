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

  String $mysql_password  = $vision_webshop::mysql_password,
  String $mysql_user      = $vision_webshop::mysql_user,
  Array[String] $environment = $vision_webshop::environment,

) {

  if ($facts['webshop_tag'] == undef) {
    $webshop_tag = 'latest'
  } else {
    $webshop_tag = $facts['webshop_tag']
  }

  $docker_environment = concat([
    'DB_SOCKET=/var/run/mysqld/mysqld.sock',
    'DB_DATABASE=webshop',
    "DB_USERNAME=${mysql_user}",
    "DB_PASSWORD=${mysql_password}",
  ], $environment)

  $compose = {
    'version' => '3.7',
    'services' => {
      'webshop' => {
        'image'       => "registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop:${webshop_tag}",
        'volumes'     => [
          '/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock',
          '/vision/data/webshop/resources:/var/www/html/resources',
          '/vision/data/webshop/logs:/var/www/html/logs',
        ],
        'environment' => $docker_environment,
        'deploy' => {
          'labels' => [
            'traefik.port=8080',
            'traefik.frontend.rule=Host:shop.vision.fraunhofer.de',
            'traefik.enable=true',
          ],
        },
      }
    }
  }
  # note: application runs on port 8080

  vision_docker::to_compose { 'webshop':
    compose => $compose,
  }

}
