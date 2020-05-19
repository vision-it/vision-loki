# Class: vision_loki::server::proxy
# ===========================
#
# Reverse Proxy for Loki
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_loki::server::proxy
#

class vision_loki::server::proxy (

  Sensitive[String] $auth,

) {

  package { 'nginx':
    ensure => present,
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }

  file { '/etc/nginx/sites-enabled/default':
    content => template('vision_loki/loki-proxy.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}
