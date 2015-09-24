#
# == Class: postgresql::install::contrib
#
# Install additional postgresql features
#
class postgresql::install::contrib
(
    $use_latest_release

) inherits postgresql::params {

    # Determine which package name to use
    $package_name = $use_latest_release ? {
        true    => "${::postgresql::params::contrib_package_name}-${::postgresql::params::latest_release}",
        false   => $::postgresql::params::contrib_package_name,
        default => $::postgresql::params::contrib_package_name,
    }

    package { 'postgresql-postgresql-contrib':
        ensure => installed,
        name   => $package_name,
    }
}
