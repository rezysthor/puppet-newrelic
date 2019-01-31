# puppet-newrelic

[![Forge Endorsement](https://img.shields.io/puppetforge/e/claranet/newrelic.svg)](https://forge.puppetlabs.com/claranet/newrelic)
[![Build Status](https://secure.travis-ci.org/claranet/puppet-newrelic.svg?branch=master)](http://travis-ci.org/claranet/puppet-newrelic)
[![Puppet Forge](http://img.shields.io/puppetforge/v/claranet/newrelic.svg)](https://forge.puppetlabs.com/claranet/newrelic)
[![Forge Downloads](https://img.shields.io/puppetforge/dt/claranet/newrelic.svg)](https://forge.puppetlabs.com/claranet/newrelic)

#### Table of Contents

1. [Description - What is the puppet-newrelic module?](#description)
1. [Setup - The basics of getting started with puppet-newrelic](#setup)
    * [What puppet-newrelic affects](#what-puppet-newrelic-affects)
    * [Beginning with puppet-newrelic](#beginning-with-registry)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Advanced Usage Examples](#advanced-usage-examples)
1. [Supported agents](#supported-agents)
    * [PHP](#php)
    * [Java](#java)
1. [Limitations - OS compatibility, etc.](#limitations)
    * [Supported Operating Systems](#supported-operating-systems)
    * [Puppet 3](#puppet-3)
    * [Server to Infra Migrations](#server-to-infra-migrations)
    * [Windows](#windows)
1. [Development - Guide for contributing to the module](#development)

## Description

This module manages and installs the New Relic Server Monitoring and PHP agents and is based on Felipe Salum's [puppet-newrelic](https://github.com/fsalum/puppet-newrelic) module.

## Setup

### What puppet-newrelic affects

  * Adds the upstream NewRelic Yum/Apt repositories
  * Installs the NewRelic Server/Infrastructure agent and also the PHP or .NET agents

### Beginning with puppet-newrelic

To use the module in its default form, which will install the NewRelic Infra agent:

    include ::newrelic

## Usage

To install the (deprecated) NewRelic Server Monitoring agent instead of the default NewRelic Infrastructure agent:

    class { '::newrelic':
      license_key   => 'your key here',
      enable_infra  => false,
      enable_server => true,
    }

## Supported Agents

### PHP

To enable the PHP agent with default configuration:

    class { '::newrelic':
      license_key      => 'your key here',
      enable_php_agent => true,
    }

Further PHP agent configuration in Hiera:

     newrelic::agent::php::ini_settings:
       appname: 'ACME PHP Application'
       daemon.loglevel: 'error'

The below examples show how to integrate the NewRelic PHP agent with the most common web-servers, with automatic service restarts.

#### Apache and `mod_php`

Assumes usage of the [Puppet Apache module](https://github.com/puppetlabs/puppetlabs-apache).

    class { '::apache': }
    class { '::apache::mod::php': }

    class { '::newrelic::agent::php':
      license_key => 'your key',
      require     => Class['::apache::mod::php'],
      notify      => Service['httpd'],

#### PHP-FPM

Assumes usage of the [Slashbunny PHP-FPM module](https://github.com/Slashbunny/puppet-phpfpm).

    class { '::phpfpm':
        poold_purge => true,
    }

    ::phpfpm::pool { 'main': }

    class { '::newrelic::agent::php':
      license_key => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
      require     => Class['::phpfpm'],
      notify      => Class['::phpfpm::service'],
    }

### Java

This module installs a specified version of the the NewRelic Java agent into an install directory. The install directory is recommended to be `newrelic/` under your app folder. Ensure permissions are correct on the install folder by using `agent_user` and `agent_group`.

**Note:** Importantly, this does not handle passing `newrelic.jar` to `JVM_OPTS` etc. Please refer to NewRelic docs here - https://docs.newrelic.com/docs/agents/java-agent/installation/install-java-agent

    class { '::newrelic::agent::java:
      license_key => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z'
    }

    # or use hiera and include
    # newrelic::agent::java::license_key: '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z'
    include ::newrelic::agent::java

## Limitations

### Supported Operating Systems

* Debian/Ubuntu
* CentOS/RHEL

### Puppet 3

On 31st December 2016, support for Puppet 3.x was withdrawn. As as a result, **this module does not support Puppet 3**.

### Server to Infra Migrations

When moving from NewRelic Server to NewRelic Infrastructure - the module only installs the new client, and does not clean up the old one.

### Windows

Please note that Windows support is currently **untested**.

## Development

* Copyright (C) 2012 Felipe Salum <fsalum@gmail.com>
* Copyright (C) 2017 Claranet
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
