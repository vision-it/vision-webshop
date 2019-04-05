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

  String $mysql_password,
  String $mysql_user,
  Array[String] $environment = [],

  ) {

  contain ::vision_docker::swarm
  contain ::vision_mysql::mariadb
  contain ::vision_gluster::node

  contain vision_webshop::config
  contain vision_webshop::database
  contain vision_webshop::docker

}
