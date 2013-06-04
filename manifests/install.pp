#
# == Class: postgresql::install
#
# Install posgresql server
#
class postgresql::install {

    include postgresql::params

	package { "postgresql-postgresql-server":
        name => $::postgresql::params::package_name,
        ensure => installed,
    }
}
