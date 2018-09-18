# Class: vision_webshop::config
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_webshop::config
#

class vision_webshop::config (

) {

  contain ::vision_jenkins::user

  vision_shipit::inotify { 'webshop_tag':
    group   => 'jenkins',
    require => Class['::vision_jenkins::user'],
  }

  file { ['/data', '/data/logs', '/data/resources']:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

}
