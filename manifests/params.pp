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
            $pid_file = '/var/run/postmaster.5432.pid'
        }
        'Debian': {
            $package_name = 'postgresql'

        }
        default: {
            $package_name = 'postgresql'
        }
    }

    # ...and Debian/Ubuntu do. Therefore we need to accurately detect the 
    # operating system to be able to place pg_hba.conf in the correct place. If 
    # the databases are originally from an earlier version of Debian (e.g. the 
    # node was upgraded) then this logic will fail.
    case $::lsbdistcodename {
        'wheezy': {
            $data_dir = '/etc/postgresql/9.1/main'
            $pid_file = '/var/run/postgresql/9.1-main.pid'
        }
        'squeeze': {
            $data_dir = '/etc/postgresql/8.4/main'
            $pid_file = '/var/run/postgresql/8.4-main.pid'
        }
    }
}
