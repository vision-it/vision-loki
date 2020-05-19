# Class: vision_loki::server::proxy
# ===========================
#
# Reverse Proxy for Loki
#
# Parameters
# ----------
#
# @param auth Content of .htpasswd (username:password)
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

  file { '/etc/nginx/.htpasswd':
    content => $auth,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { '/etc/nginx/sites-enabled/default':
    content => template('vision_loki/loki-proxy.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}
