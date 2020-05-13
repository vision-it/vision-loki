# Class: vision_loki::promtail
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_loki::promtail
#

class vision_loki::promtail (

  Hash $config,
  String $checksum = 'b94dd911948277b87d6daef50cfbb299f4007e082849c5327fe96239d740ecef',

) {

  contain archive

  # Config
  file { ['/etc/promtail', '/var/lib/promtail']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/promtail/config.yaml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => template('vision_loki/promtail-config.yaml.erb'),
    require => File['/etc/promtail'],
  }

  # Install
  archive { "/tmp/promtail.zip":
    ensure        => present,
    source        => 'https://github.com/grafana/loki/releases/download/v1.4.1/promtail-linux-amd64.zip',
    extract       => true,
    extract_path  => '/usr/local/bin/',
    creates       => '/usr/local/bin/promtail-linux-amd64',
    checksum      => $checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

  # Service
  file { '/etc/systemd/system/promtail.service':
    ensure  => present,
    content => template('vision_loki/promtail.service.erb'),
    notify  => Service['promtail'],
  }

  service { 'promtail':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      File['/etc/systemd/system/promtail.service'],
      File['/etc/promtail/config.yaml'],
    ],
  }

}
