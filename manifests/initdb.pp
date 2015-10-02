#
# == Class: postgresql::initdb
#
# Initialize/create the postgresql database directory. This is needed on RedHat 
# family of operating systems, but not on Debian derivatives.
#
class postgresql::initdb
(
    $use_latest_release

) inherits postgresql::params {

    case $use_latest_release {
        true: {
            $pg_hba_conf = $::postgresql::params::latest_pg_hba_conf
            $initdb_cmd = $::postgresql::params::latest_initdb_cmd
            $service_start = $::postgresql::params::latest_service_start
        }
        false: {
            $pg_hba_conf = $::postgresql::params::pg_hba_conf
            $initdb_cmd = $::postgresql::params::initdb_cmd
            $service_start = $::postgresql::params::service_start
        }
        default: {
            fail("Unsupported value ${use_latest_release} for \$use_latest_release")
        }
    }

    exec { 'postgresql-initdb':
        command => $initdb_cmd,
        creates => $pg_hba_conf,
        path    => [ '/bin', '/usr/bin', '/usr/sbin', '/sbin' ],
        require => Class['postgresql::install'],
        notify  => Exec['postgresql-start'],
    }

    # Start postgresql after the cluster has been initialized
    exec { 'postgresql-start':
        command     => $service_start,
        path        => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        refreshonly => true,
        require     => Exec['postgresql-initdb'],
    }
}
