# = Class: cache::opcache
#
# Memory object caching
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define cache::opcache (
  $max_accelerated_files = 7963,
  $memory_consumption = 192,
  $interned_strings_buffer = 16,
  $fast_shutdown = 1,
  $prod_mode = false,
) {

  # comment out validate_timestamps in dev environment and set validate_timestamps=0 in prod
  $validate_timestamps = '#opcache.validate_timestamps=0'
  if $prod_mode {
    $validate_timestamps = 'opcache.validate_timestamps=0'
  }


  file { '/etc/php/7.0/mods-available/opcache.ini':
    path    => "/etc/php/7.0/mods-available/opcache.ini",
    # this sets up the relationship
    notify  => Service['php7.0-fpm'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['php'],
    content => template('cache/opcache.ini.erb'),
  }

}
