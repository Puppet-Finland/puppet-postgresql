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
            $pidfile = '/var/run/postmaster.5432.pid'
            $service_name = 'postgresql'

            if $::operatingsystem == 'Fedora' {
                $service_start = "/usr/bin/systemctl start ${service_name}.service"
                $service_stop = "/usr/bin/systemctl stop ${service_name}.service"
            } else {
                $service_start = "/sbin/service $service_name start"
                $service_stop = "/sbin/service $service_name stop"
            }
        }
        'Debian': {
            $package_name = 'postgresql'
            $service_name = 'postgresql'
            $service_start = "/usr/sbin/service $service_name start"
            $service_stop = "/usr/sbin/service $service_name stop"
        }
        default: {
            fail("Unsupported operating system: ${::osfamily}/${::operatingsystem}")
        }
    }

    # ...and Debian/Ubuntu do. Therefore we need to accurately detect the 
    # operating system to be able to place pg_hba.conf in the correct place. If 
    # the databases are originally from an earlier version of Debian (e.g. the 
    # node was upgraded) then this logic will fail.
    case $::lsbdistcodename {
        'trusty': {
            $data_dir = '/etc/postgresql/9.3/main'
            $pidfile = '/var/run/postgresql/9.3-main.pid'
        }
        'wheezy': {
            $data_dir = '/etc/postgresql/9.1/main'
            $pidfile = '/var/run/postgresql/9.1-main.pid'
        }
        'squeeze': {
            $data_dir = '/etc/postgresql/8.4/main'
            $pidfile = '/var/run/postgresql/8.4-main.pid'
        }
    }
}
