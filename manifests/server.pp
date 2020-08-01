# Class: vision_loki::server
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_loki
#

class vision_loki::server (

  String $version,
  String $checksum,

) {

  contain archive

  # Install
  archive { '/tmp/loki.zip':
    ensure        => present,
    source        => "https://github.com/grafana/loki/releases/download/${version}/loki-linux-amd64.zip",
    extract       => true,
    extract_path  => '/usr/local/bin/',
    creates       => '/usr/local/bin/loki-linux-amd64',
    checksum      => $checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

  # Config
  file { ['/etc/loki']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  # General settings
  file { '/etc/loki/config.yaml':
    content => file('vision_loki/loki-config.yaml'),
    require => File['/etc/loki'],
    notify  => Service['loki'],
  }

  # Service
  file { '/etc/systemd/system/loki.service':
    ensure  => present,
    content => file('vision_loki/loki.service'),
    notify  => Service['loki'],
  }

  service { 'loki':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      File['/etc/systemd/system/loki.service'],
      File['/etc/loki/config.yaml'],
    ],
  }

}
