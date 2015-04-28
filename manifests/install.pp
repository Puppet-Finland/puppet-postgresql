#
# == Class: postgresql::install
#
# Install posgresql server
#
class postgresql::install {

    include ::postgresql::params

    package { 'postgresql-postgresql-server':
        ensure => installed,
        name   => $::postgresql::params::package_name,
    }
}
