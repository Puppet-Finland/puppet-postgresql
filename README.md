# postgresql

A Puppet module for managing postgresql servers

# Module usage

Instructions for using the included classes and defines:

* [Class: postgresql](manifests/init.pp)
* [Define: postgresql::backup](manifests/backup.pp)
* [Define: postgresql::loadsql](manifests/loadsql.pp)

Usage instructions for the bundled types and providers is here:

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

Most classes and defines are licensed under the BSD license (see file 
LICENSE.BSD). The types, providers and classes included from 
postgresql::softwarerepo class have been taken from puppetlabs-postgresql (HEAD 
at 0ffbcc0). These files are thus covered by the Apache 2.0 license (see file 
LICENSE.APACHE).
