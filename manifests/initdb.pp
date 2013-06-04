#
# == Class: postgresql::initdb
#
# Initialize/create the postgresql database directory. This is needed on RedHat 
# family of operating systems, but not on Debian derivatives.
#
class postgresql::initdb {

    exec { 'exec-postgresql-initdb':
        command => 'service postgresql initdb',
        creates => '/var/lib/pgsql/data',
        path => [ '/usr/sbin', '/sbin' ],
        require => Class['postgresql::install'],
    }
}
