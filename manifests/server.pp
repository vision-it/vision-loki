# Class: vision_loki::server
# ===========================
#
# Parameters
# ----------
#
# @param version Version to download
# @param checksum Sha256 of downloaded file
#
# Examples
# --------
#
# @example
# contain ::vision_loki::server
#

class vision_loki::server (

  String $version,
  String $checksum,

) {

  contain archive

  # Install via GitHub Binary
  archive { '/tmp/loki.zip':
    ensure        => present,
    source        => "https://github.com/grafana/loki/releases/download/${version}/loki-linux-amd64.zip",
    extract       => true,
    extract_path  => '/usr/local/bin/',
    checksum      => $checksum,
    checksum_type => 'sha256',
    cleanup       => false,
  }

  # Config directory
  file { ['/etc/loki']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  # General server settings
  file { '/etc/loki/config.yaml':
    content => file('vision_loki/loki-config.yaml'),
    require => File['/etc/loki'],
    notify  => Service['loki'],
  }

  # Systemd Service Unit
  file { '/etc/systemd/system/loki.service':
    ensure  => present,
    content => file('vision_loki/loki.service'),
    notify  => Service['loki'],
  }

  service { 'loki':
    ensure    => running,
    enable    => true,
    provider  => 'systemd',
    subscribe => Archive['/tmp/loki.zip'],
    require   => [
      File['/etc/systemd/system/loki.service'],
      File['/etc/loki/config.yaml'],
    ],
  }
}
