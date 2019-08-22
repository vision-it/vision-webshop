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

  String $mysql_password = $vision_webshop::mysql_password,
  String $mysql_user = $vision_webshop::mysql_user,

  ) {

  ::mysql::db { 'webshop':
    user     => $mysql_user,
    password => $mysql_password,
    host     => 'localhost',
    grant    => [ 'SELECT', 'UPDATE', 'CREATE', 'INSERT', 'ALTER', 'DELETE', 'DROP' ],
  }

}
