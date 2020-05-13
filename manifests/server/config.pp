# Class: vision_loki::server::config
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_loki::server::config
#

class vision_loki::server::config (

) {

  file { ['/vision/data/loki', '/vision/data/loki/data/']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  # General settings
  file { '/vision/data/loki/config.yaml':
    content => template('vision_loki/loki-config.yaml.erb'),
    require => File['/vision/data/loki']
  }

}
