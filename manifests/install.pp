#
# == Class: pf_postgresql::install
#
# Install posgresql server
#
class pf_postgresql::install
(
    $use_latest_release

) inherits pf_postgresql::params
{

    # Determine which package name to use
    $package_name = $use_latest_release ? {
        true    => $::pf_postgresql::params::latest_package_name,
        false   => $::pf_postgresql::params::package_name,
        default => $::pf_postgresql::params::package_name,
    }

    package { 'postgresql-postgresql-server':
        ensure  => installed,
        name    => $package_name,
        require => Class['pf_postgresql::softwarerepo'],
    }
}
