# == Class: newrelic::agent::php
#
# This class install the New Relic PHP Agent
#
# === Parameters:
#
# [*license_key*]
#   NewRelic API license key (String)
#
# [*manage_repo*]
#   Whether to install the NewRelic OS repositories
#   Default: OS dependant - see params.pp (Boolean)
#
# [*conf_dir*]
#   Main Configuration directory used for PHP.
#   Default: OS dependant - see params.pp (String)
#
# [*purge_files*]
#   Any files which should be purged following the installation. This is only
#   necessary as the NewRelic installer adds files to every possible location,
#   resulting in duplicate configuration.
#   Default: OS dependant - see params.pp (Array)
#
# [*package_name*]
#   Name of the package to install
#   Default: OS dependant - see params.pp (String)
#
# [*service_name*]
#   Name of the service running the PHP agent
#   Default: OS dependant - see params.pp (String)
#
# [*extra_packages*]
#   Any extra packages to install before running the install script. For example
#   if using PHP-FPM on RedHat distros, some Puppet modules do not install the
#   required php-cli package, so the installer fails to find any PHP
#   installations.
#   Default: OS dependant - see params.pp (Array)
#
# [*package_ensure*]
#   Specific the Newrelic PHP package update state.
#   Default: 'present' (String)
#
# [*startup_mode*]
#   Sets the startup mode to either 'agent' or 'external'. When set to 'agent',
#   the newrelic-daemon service will not be managed by Puppet.
#   For more detail, see: https://docs.newrelic.com/docs/agents/php-agent/advanced-installation/starting-php-daemon-advanced
#   Default: 'agent' (String)
#
# [*ini_settings*]
#   Key/Value hash of settings to add to newrelic.ini files within $conf_dir,
#   see below example. NOTE that all settings are added to the [newrelic]
#   section with the "newrelic." prefix. For more info on possible parameters,
#   see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
#   Default: {} (Hash)
#
# === Examples
#
# To set a custom application name and disable the daemon service
#
# class { '::newrelic::agent::php':
#   license_key   => 'your license key here',
#   daemon_enable => false,
#   ini_settings  => {
#     'appname' => 'My PHP Application',
#   },
# }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright
#
# Copyright 2012 Felipe Salum
# Copyright 2017 Claranet
#
class newrelic::agent::php (
  String                   $license_key,
  Boolean                  $manage_repo         = $::newrelic::params::manage_repo,
  String                   $conf_dir            = $::newrelic::params::php_conf_dir,
  Array                    $purge_files         = $::newrelic::params::php_purge_files,
  String                   $package_name        = $::newrelic::params::php_package_name,
  String                   $daemon_service_name = $::newrelic::params::php_service_name,
  Array                    $extra_packages      = $::newrelic::params::php_extra_packages,
  Hash                     $extra_ini_settings  = $::newrelic::params::php_default_ini_settings,
  String                   $exec_path           = $facts['path'],
  String                   $package_ensure      = 'present',
  Enum['agent','external'] $startup_mode        = 'agent',
  Hash                     $ini_settings        = {},
  Hash                     $daemon_settings     = {},
) inherits newrelic::params {

  if $startup_mode == 'agent' {
    $daemon_config_ensure = absent
    $daemon_service_ensure = 'stopped'
    $daemon_service_enable = false
  } else {
    $daemon_config_ensure = file
    $daemon_service_ensure = 'running'
    $daemon_service_enable = true
    File['/etc/newrelic/newrelic.cfg']{
      notify  => Service[$service_name],
    }
  }

  # == Installation

  if $manage_repo == true {
    include ::newrelic::repo::legacy
    Package[$package_name] {
      require => $::newrelic::repo::legacy::require
    }
  }

  $all_packages = concat($extra_packages,[$package_name])
  ensure_packages($extra_packages)

  package { $package_name:
    ensure  => $package_ensure,
  }

  # == Configuration

  exec { 'newrelic install':
    command => "/usr/bin/newrelic-install purge; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${license_key} /usr/bin/newrelic-install install",
    path    => $exec_path,
    user    => 'root',
    unless  => "/bin/grep -q ${license_key} ${conf_dir}/newrelic.ini",
    require => Package[$all_packages],
  }

  $all_ini_settings = deep_merge($extra_ini_settings,$ini_settings)

  file { "${conf_dir}/newrelic.ini":
    ensure  => file,
    content => template('newrelic/php/newrelic.ini.erb'),
    require => Exec['newrelic install'],
  }

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $daemon_config_ensure,
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/daemon/newrelic.cfg.erb'),
    require => Exec['newrelic install'],
  }

  file { $purge_files:
    ensure  => absent,
    require => Exec['newrelic install']
  }

  # == Service only managed in external startup mode

  service { $daemon_service_name:
    ensure     => $daemon_service_ensure,
    enable     => $daemon_service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/newrelic/newrelic.cfg'],
  }

}
