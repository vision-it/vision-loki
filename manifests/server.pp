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

) {

  contain vision_loki::server::docker
  contain vision_loki::server::config
  contain vision_loki::server::proxy

}
