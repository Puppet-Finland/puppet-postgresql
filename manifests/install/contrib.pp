#
# == Class: postgresql::install::contrib
#
# Install additional postgresql features
#
class postgresql::install::contrib
(
    Boolean $use_latest_release = false

) inherits postgresql::params {

    # Determine which package name to use
    $package_name = $use_latest_release ? {
        true    => $::postgresql::params::latest_contrib_package_name,
        false   => $::postgresql::params::contrib_package_name,
        default => $::postgresql::params::contrib_package_name,
    }

    package { 'postgresql-postgresql-contrib':
        ensure => installed,
        name   => $package_name,
    }
}
