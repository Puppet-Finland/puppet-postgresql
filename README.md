# postgresql

A Puppet module for managing postgresql servers

# Module usage

Instructions for using the included classes and defines:

* [Class: postgresql](manifests/init.pp)
* [Define: postgresql::backup](manifests/backup.pp)
* [Define: postgresql::loadsql](manifests/loadsql.pp)

The bundled types and providers have been copied from puppetlabs/postgresql 
(HEAD at 0ffbcc0). For usage instructions please refer here:

* https://github.com/puppetlabs/puppetlabs-postgresql

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Ubuntu 12.04
* Debian 7 and 8

The following operating systems should work out of the box or with small 
modifications:

* CentOS 6

For details see [params.pp](manifests/params.pp).

# License

The classes and defines are licensed under the BSD license (see file 
LICENSE.BSD). The types and providers are taken from puppetlabs-postgresql and 
are covered by the Apache 2.0 license (see file LICENSE.APACHE).
