# Class: vision_loki::promtail
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
# contain ::vision_loki::promtail
#

class vision_loki::promtail (

  Hash   $config,
  Array  $scrape_configs,
  String $version,
  String $checksum,

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
    notify  => Service['promtail'],
  }

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
