# = Class: cache::memcached
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
define cache::memcached (
  $project = $title,
  $port ='11211',
  $memory ='256',
  $php = true,
  $python = false
) {

  # install php package
  package { 'memcached':
    require => Exec['apt-update'],
    ensure  => installed,
  }

  if ($php == true) {
    package { 'php-memcached':
      ensure  => latest,
      require => Package['php'],
      notify  => Service['apache2'],
    }
  }

  if ($python == true) {
    package { 'python-memcached':
      ensure   => latest,
      provider => 'pip',
      require  => Package['python-pip'],
    }
  }


  # add a notify to the file resource
  file { '/etc/memcached.conf':
    path    => "/etc/memcached.conf",
    # this sets up the relationship
    notify  => Service['apache2'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package['memcached'],
    content => template('cache/memcached.conf.erb'),
  }

}
