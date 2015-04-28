#
# == Class: postgresql::params
#
# Defines some variables based on the operating system
#
class postgresql::params {

    include ::os::params

    # RedHat derivatives don't shuffle the postgresql database directory around 
    # depending on the server version...
    case $::osfamily {
        'RedHat': {
            $package_name = 'postgresql-server'
            $data_dir = '/var/lib/pgsql/data'
            $pg_hba_conf = "${data_dir}/pg_hba.conf"
            $pidfile = '/var/run/postmaster.5432.pid'
            $service_name = 'postgresql'
            $daemon_user = 'postgres'
        }

        # ...and Debian/Ubuntu do. Therefore we need to accurately detect the 
        # operating system to be able to place pg_hba.conf in the correct place. If 
        # the databases are originally from an earlier version of Debian (e.g. the 
        # node was upgraded) then this logic will fail.
        'Debian': {
            case $::lsbdistcodename {
                'jessie':            { $ver = 9.4 }
                'trusty':            { $ver = 9.3 }
                'wheezy', 'precise': { $ver = 9.1 }
                'squeeze':           { $ver = 8.4 }
                default:             { fail("Unsupported distribution: ${::lsbdistcodename}") }
            }

            $package_name = 'postgresql'
            $data_dir = "/etc/postgresql/${ver}/main"
            $pg_hba_conf = "${data_dir}/pg_hba.conf"
            $pidfile = "/var/run/postgresql/${ver}-main.pid"
            $service_name = 'postgresql'
            $daemon_user = 'postgres'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    if str2bool($::has_systemd) {
        $service_start = "${::os::params::systemctl} start ${service_name}"
        $service_stop = "${::os::params::systemctl} stop ${service_name}"
    } else {
        $service_start = "${::os::params::service_cmd} ${service_name} start"
        $service_stop = "${::os::params::service_cmd} ${service_name} stop"
    }
}
