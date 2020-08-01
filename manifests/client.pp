# Class: vision_loki::client
# ===========================
#
# Parameters
# ----------
#
# @param config Content of config.yaml as Hash
# @param scrape_configs Array of scrape_config Hashes
# @param version Version to download
# @param checksum Sha256 of downloaded file
#
# Examples
# --------
#
# @example
# contain ::vision_loki::client
#

class vision_loki::client (

  Array  $scrape_configs,
  String $server_address,
  String $version,
  String $checksum,

) {

  contain archive

  # Install
  archive { '/tmp/promtail.zip':
    ensure        => present,
    source        => "https://github.com/grafana/loki/releases/download/${version}/promtail-linux-amd64.zip",
    extract       => true,
    extract_path  => '/usr/local/bin/',
    creates       => '/usr/local/bin/promtail-linux-amd64',
    checksum      => $checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

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
    notify  => Service['promtail'],
  }

  # Service
  file { '/etc/systemd/system/promtail.service':
    ensure  => present,
    content => file('vision_loki/promtail.service'),
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
