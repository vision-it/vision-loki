# Class: vision_loki::server::docker
# ===========================
#
# Parameters
# ----------
#
# Examples
# --------
#
# @example
# contain ::vision_loki::server::docker
#

class vision_loki::server::docker (

  String $version = $::vision_loki::server::version,

) {

  contain ::vision_docker

  ::docker::image { 'loki':
    ensure    => present,
    image     => 'grafana/loki',
    image_tag => $version,
    require   => Class['vision_docker']
  }

  ::docker::run { 'loki':
    image   => "grafana/loki:${version}",
    ports   => [ '3100:3100' ],
    command => '-config.file=/etc/loki/config.yaml',
    volumes => [
      '/vision/data/loki/data/:/var/lib/loki',
      '/vision/data/loki/config.yaml:/etc/loki/config.yaml',
    ],
  }

}
