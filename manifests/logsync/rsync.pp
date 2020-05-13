# Class: vision_loki::logsync::rsync
# ===========================
#
# Resource to pull files regularly
#
# Parameters
# ----------
#
# @param source_dir Source directory for rsync
# @param target_dir Target directory for rsync
# @param interval Interval for Timer (e.g. 10s, 20m, 3h)
#
# Examples
# --------
#
# @example
# contain ::vision_loki::logsync::rsync
#

define vision_loki::logsync::rsync (

  String $source_dir,
  String $target_dir,
  String $interval = '15m',
  String $service = $title,

) {

  # Service File
  $service_file = "/etc/systemd/system/${service}.service"
  $timer_file   = "/etc/systemd/system/${service}.timer"
  $command_file = "/usr/local/bin/${service}.sh"

  # Command to execute
  file { $command_file:
    ensure  => present,
    content => template('vision_loki/logsync.sh.erb'),
  }

  # Service Unit
  file { $service_file:
    ensure  => present,
    content => template('vision_loki/logsync.service.erb'),
  }

  # Timer Unit
  file { $timer_file:
    ensure  => present,
    content => template('vision_loki/logsync.timer.erb'),
    notify  => Service[$service],
  }

  service { $service:
    ensure   => running,
    enable   => true,
    name     => "${service}.timer",
    provider => 'systemd',
    require  => [
      File[$service_file],
      File[$timer_file],
      File[$command_file],
    ],
  }

}
