#
# == Class: postgresql::install::contrib
#
# Install additional postgresql features
#
class postgresql::install::contrib inherits postgresql::params {

    package { 'postgresql-postgresql-contrib':
        ensure => installed,
        name   => $::postgresql::params::contrib_package_name,
    }
}
