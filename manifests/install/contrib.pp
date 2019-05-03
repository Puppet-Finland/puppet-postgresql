#
# == Class: pf_postgresql::install::contrib
#
# Install additional postgresql features
#
class pf_postgresql::install::contrib
(
    Boolean $use_latest_release = false

) inherits pf_postgresql::params {

    # Determine which package name to use
    $package_name = $use_latest_release ? {
        true    => $::pf_postgresql::params::latest_contrib_package_name,
        false   => $::pf_postgresql::params::contrib_package_name,
        default => $::pf_postgresql::params::contrib_package_name,
    }

    package { 'postgresql-postgresql-contrib':
        ensure => installed,
        name   => $package_name,
    }
}
