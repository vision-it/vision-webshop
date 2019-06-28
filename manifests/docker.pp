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
  Integer $port           = $vision_webshop::port,
  Array[String] $docker_volumes = $vision_webshop::docker_volumes,
  Array[String] $environment = $vision_webshop::environment,

) {

  contain ::vision_docker

  if ($facts['webshop_tag'] == undef) {
    $webshop_tag = 'latest'
    } else {
      $webshop_tag = $facts['webshop_tag']
  }

  ::docker::image { 'webshop':
    ensure    => present,
    image     => 'registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop',
    image_tag => $webshop_tag,
  }

  $docker_environment = concat([
    "DB_HOST=${mysql_host}",
    "DB_DATABASE=${mysql_database}",
    "DB_USERNAME=${mysql_user}",
    "DB_PASSWORD=${mysql_password}",
  ], $environment)

  ::docker::run { 'webshop':
    image   => "registry.gitlab.cc-asp.fraunhofer.de:4567/vision-it/application/webshop:${webshop_tag}",
    env     => $docker_environment,
    ports   => [ "${port}:80" ],
    volumes => $docker_volumes,
  }

}
