# Class: vision_loki::logsync
# ===========================
#
# Service to pull files regularly
#
# Parameters
# ----------
#
# @param jobs List of Jobs to apply
#
# Examples
# --------
#
# @example
# contain ::vision_loki::logsync
#

class vision_loki::logsync (

  Hash $jobs

) {

  package { 'rsync':
    ensure => present,
  }

  create_resources('vision_loki::logsync::rsync', $jobs)

}
