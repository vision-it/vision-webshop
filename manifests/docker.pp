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
  String $ldap_password   = $vision_webshop::ldap_password,
  String $ldap_host       = $vision_webshop::ldap_host,
  Array[String] $environment = $vision_webshop::environment,
  String $traefik_rule    = $vision_webshop::traefik_rule,
  String $webshop_digest  = $vision_webshop::webshop_tag,

) {

  ::docker::image { 'webshop':
    ensure       => present,
    image        => 'registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop',
    image_digest => $webshop_digest,
  }

  $docker_environment = concat([
    'DB_SOCKET=/var/run/mysqld/mysqld.sock',
    'DB_DATABASE=webshop',
    "DB_USERNAME=${mysql_user}",
    "DB_PASSWORD=${mysql_password}",
    "LDAP_BIND_PASSWORD=${ldap_password}",
    "LDAP_HOST=${ldap_host}",
  ], $environment)

  $compose = {
    'version' => '3.7',
    'services' => {
      'webshop' => {
        'image'       => "registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop@${webshop_digest}",
        'volumes'     => [
          '/var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock',
          '/vision/data/webshop/resources:/var/www/html/resources',
          '/vision/data/webshop/logs:/var/www/html/logs',
        ],
        'environment' => $docker_environment,
        'deploy' => {
          'replicas' => 2,
          'labels'   => [
            'traefik.enable=true',
            'traefik.http.services.webshop.loadbalancer.server.port=8080',
            'traefik.http.services.webshop.loadbalancer.sticky=true',
            'traefik.http.services.webshop.loadbalancer.sticky.cookie.secure=true',
            'traefik.http.services.webshop.loadbalancer.sticky.cookie.httpOnly=true',
            "traefik.http.routers.webshop.rule=${traefik_rule}",
            'traefik.http.routers.webshop.entrypoints=https',
            'traefik.http.routers.webshop.tls=true',
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
