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

  contain ::vision_shipit::user

  vision_shipit::inotify { 'webshop_tag':
    group   => 'shipit',
    require => Class['::vision_shipit::user'],
  }

  file { ['/vision/data/webshop', '/vision/data/webshop/logs', '/vision/data/webshop/resources']:
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
  }

  file { '/usr/local/sbin/sync-webshop.sh':
    ensure  => present,
    owner   => 'root',
    mode    => '0750',
    content => template('vision_webshop/sync-webshop.sh.erb'),
  }

}
