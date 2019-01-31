# Change Log

Release notes for the claranet/puppet-newrelic module.

------------------------------------------

# 2.4.2 - 2019-01-31
  * README: Making changes due to Puppet Approved review - [MODULES-7737](https://tickets.puppetlabs.com/browse/MODULES-7737)
  * PHP Agent: Added support for Debian 9 natively using PHP7 - [#21](https://github.com/claranet/puppet-newrelic/pull/19)
  * Metadata: Adding upper bound to Puppet version support and signalling Puppet 6 support
  * Metadata: Now supporting `puppetlabs/apt` version 6.x and `puppetlabs/stdlib` version 5.x - [#22](https://github.com/claranet/puppet-newrelic/pull/22)
  * PDK: Now compatible with PDK 1.9.0

# 2.4.1 - 2018-08-29
  * The module is now compatible with the Puppet Development Kit, version 1.7.0 and above.

# 2.4.0 - 2018-08-29
  * New Agent: Java! The module can now install and configure the NewRelic Java agent via the `::newrelic::agent::java` class
  * Massive thanks to [DaveHewey](https://github.com/DaveHewy) for PR [#20](https://github.com/claranet/puppet-newrelic/pull/19)

# 2.3.0 - 2018-07-26
  * Infra Class: Added parameters to manage the service - [#19](https://github.com/claranet/puppet-newrelic/pull/19)

## 2.2.0 - 2018-03-20
  * PHP Agent: Removed `purge_files` parameter and introduced a `run_installer` parameter (`true` on Debian only) to fix a duplicate files bug - [#16](https://github.com/claranet/puppet-newrelic/pull/16)
  * Main class: Added `contain` statements to fix ordering of resources - [#17](https://github.com/claranet/puppet-newrelic/pull/17)

## 2.1.0 - 2017-11-22
  * PHP Agent: Fixed a bug where the `newrelic-daemon` service would flap if the start-up mode was set to `agent` - [#13](https://github.com/claranet/puppet-newrelic/issues/13)
  * PHP Agent: New parameter: `default_daemon_settings` for external start-up mode - [#12](https://github.com/claranet/puppet-newrelic/pull/12)

## 2.0.1 - 2017-10-04
  * Infra Repo: Apt module now handles setting `release` for Debian osfamily - [#11](https://github.com/claranet/puppet-newrelic/issues/11)
  * Linux Server: Exec now creates `/etc/newrelic/nrsysmond.cfg` before `nrsysmond-config` is run
  * Dependencies: Apt has been relaxed to `>= 2.3.0`

## 2.0.0 - 2017-08-23
  * Major rewrite of module
  * Please note that Windows support is _untested_

## 1.1.0 - 2017-08-11
  * Managing repo now optional

## 1.0.0 - 2017-08-08
  * Initial Forge Release
