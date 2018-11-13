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
  Integer $port = 80,
  Array[String] $docker_volumes = [],

) {

  contain vision_webshop::config
  contain vision_webshop::database
  contain vision_webshop::docker

}
