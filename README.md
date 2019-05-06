# postgresql

A Puppet module for managing postgresql servers and configuring database dumps. 
Reuses providers from puppetlabs-postgresql. Includes optional firewall and 
monit support.

# Module usage

Setup latest postgresql version from the project's repositories:

    class { '::pf_postgresql':
      use_latest_release => true,
    }

Configure a backup job with default settings:

    pf_postgresql::backup { 'my_database_name': }

Customize backup schedule:

    pf_postgresql::backup { 'my_database_name':
      hour    => 4,
      minute  => 45,
      weekday => *',
    }

The $pg_dump_extra_params parameter can be used to customize the backup job 
further.

To load an SQL file (generally from another module):

    pf_postgresql::loadsql { 'bacula-bacula-director.sql':
      modulename => 'bacula',
      basename   => 'bacula-director',
    }

For details see [init.pp](manifests/init.pp), [backup.pp](manifests/backup.pp) 
and [loadsql.pp](manifests/loadsql.pp)

Usage instructions for the bundled types and providers is here:

* https://github.com/puppetlabs/puppetlabs-postgresql

# License

Most classes and defines are licensed under the BSD license (see file 
LICENSE.BSD). The types, providers and classes included from 
postgresql::softwarerepo class have been taken from puppetlabs-postgresql (HEAD 
at 0ffbcc0). These files are thus covered by the Apache 2.0 license (see file 
LICENSE.APACHE).
