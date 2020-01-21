#
# == Class: pf_postgresql::params
#
# Defines some variables based on the operating system
#
class pf_postgresql::params {

    include ::os::params

    # Latest release available in the postgresql apt/yum repositories
    $latest_release = '9.4'
    $latest_release_alt = '94'

    # RedHat derivatives don't shuffle the postgresql database directory around 
    # depending on the server version...
    case $::osfamily {
        'RedHat': {
            $daemon_user = 'postgres'

            $package_name = 'postgresql-server'
            $contrib_package_name = 'postgresql-contrib'
            $data_dir = '/var/lib/pgsql/data'
            $pg_hba_conf = "${data_dir}/pg_hba.conf"
            $pidfile = '/var/run/postmaster.5432.pid'
            $service_name = 'postgresql'
            $initdb_cmd = $::operatingsystemmajrelease ? {
                '7'     => 'postgresql-setup initdb',
                '6'     => 'service postgresql initdb',
                default => 'postgresql-setup initdb',
            }

            $latest_package_name = "postgresql${latest_release_alt}-server"
            $latest_contrib_package_name = "postgresql${latest_release_alt}-contrib"
            $latest_data_dir = "/var/lib/pgsql/${latest_release}/data"
            $latest_pg_hba_conf = "${latest_data_dir}/pg_hba.conf"
            $latest_pidfile = "/var/lib/pgsql/${latest_release}/data/postmaster.pid"
            $latest_service_name = "postgresql-${latest_release}"
            $latest_initdb_cmd = $::operatingsystemmajrelease ? {
                '7'     => "/usr/pgsql-${latest_release}/bin/postgresql${latest_release_alt}-setup initdb",
                '6'     => "service postgresql${latest_release_alt} initdb",
                default => "/usr/pgsql-${latest_release}/bin/postgresql${latest_release_alt}-setup initdb",
            }
        }

        # ...and Debian/Ubuntu do. Therefore we need to accurately detect the 
        # operating system to be able to place pg_hba.conf in the correct place. If 
        # the databases are originally from an earlier version of Debian (e.g. the 
        # node was upgraded) then this logic will fail.
        'Debian': {
            # Latest version available in the distribution's own repositories
            case $::lsbdistcodename {
                'bionic':            { $ver = 9.6 }
                'xenial':            { $ver = 9.5 }
                'jessie':            { $ver = 9.4 }
                'trusty':            { $ver = 9.3 }
                'wheezy', 'precise': { $ver = 9.1 }
                'squeeze':           { $ver = 8.4 }
                default:             { fail("Unsupported distribution: ${::lsbdistcodename}") }
            }

            $package_name = 'postgresql'
            $contrib_package_name = 'postgresql-contrib'
            $data_dir = "/etc/postgresql/${ver}/main"
            $pg_hba_conf = "${data_dir}/pg_hba.conf"
            $pidfile = "/var/run/postgresql/${ver}-main.pid"
            $service_name = 'postgresql'
            $daemon_user = 'postgres'

            $latest_package_name = "postgresql-${latest_release}"
            $latest_contrib_package_name = "postgresql-contrib-${latest_release}"
            $latest_pg_hba_conf = "/etc/postgresql/${latest_release}/main/pg_hba.conf"
            $latest_pidfile = "/var/run/postgresql/${latest_release}-main.pid"
            $latest_service_name = 'postgresql'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
        $latest_service_start = "${::os::params::systemctl} start ${latest_service_name}"
        $latest_service_stop = "${::os::params::systemctl} stop ${latest_service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
        $latest_service_start = "${::os::params::service_cmd} ${latest_service_name} start"
        $latest_service_stop = "${::os::params::service_cmd} ${latest_service_name} stop"
    }
}
