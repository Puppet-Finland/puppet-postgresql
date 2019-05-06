#
# == Class: pf_postgresql::initdb
#
# Initialize/create the postgresql database directory. This is needed on RedHat 
# family of operating systems, but not on Debian derivatives.
#
class pf_postgresql::initdb
(
    $use_latest_release

) inherits pf_postgresql::params {

    case $use_latest_release {
        true: {
            $pg_hba_conf = $::pf_postgresql::params::latest_pg_hba_conf
            $initdb_cmd = $::pf_postgresql::params::latest_initdb_cmd
            $service_start = $::pf_postgresql::params::latest_service_start
        }
        false: {
            $pg_hba_conf = $::pf_postgresql::params::pg_hba_conf
            $initdb_cmd = $::pf_postgresql::params::initdb_cmd
            $service_start = $::pf_postgresql::params::service_start
        }
        default: {
            fail("Unsupported value ${use_latest_release} for \$use_latest_release")
        }
    }

    exec { 'postgresql-initdb':
        command => $initdb_cmd,
        creates => $pg_hba_conf,
        path    => [ '/bin', '/usr/bin', '/usr/sbin', '/sbin' ],
        require => Class['pf_postgresql::install'],
        notify  => Exec['pf_postgresql-start'],
    }

    # Start postgresql after the cluster has been initialized
    exec { 'postgresql-start':
        command     => $service_start,
        path        => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
        refreshonly => true,
        require     => Exec['pf_postgresql-initdb'],
    }
}
