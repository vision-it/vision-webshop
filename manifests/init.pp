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
  String $ldap_password,
  String $ldap_host,
  String $ldap_base_dn,
  Array[String] $environment = [],
  String $traefik_rule = 'Host(`shop.vision.fraunhofer.de`)||Host(`shop.vision.fhg.de`)',
  String $webshop_tag  = $facts['webshop_tag'],

) {

  # contain ::vision_mysql::mariadb

  contain vision_webshop::config
  # contain vision_webshop::database
  contain vision_webshop::docker

}
