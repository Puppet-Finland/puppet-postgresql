#
# == Class: postgresql::params
#
# Defines some variables based on the operating system
#
class postgresql::params {

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

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
        }

        # ...and Debian/Ubuntu do. Therefore we need to accurately detect the 
        # operating system to be able to place pg_hba.conf in the correct place. If 
        # the databases are originally from an earlier version of Debian (e.g. the 
        # node was upgraded) then this logic will fail.
        'Debian': {
            case $::lsbdistcodename {
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
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
            $daemon_user = 'postgres'
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }
}
