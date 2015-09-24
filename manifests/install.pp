#
# == Class: postgresql::install
#
# Install posgresql server
#
class postgresql::install
(
    $use_latest_release

) inherits postgresql::params
{

    # Determine which package name to use
    $package_name = $use_latest_release ? {
        true    => "${::postgresql::params::package_name}-${::postgresql::params::latest_release}",
        false   => $::postgresql::params::package_name,
        default => $::postgresql::params::package_name,
    }

    package { 'postgresql-postgresql-server':
        ensure  => installed,
        name    => $package_name,
        require => Class['postgresql::softwarerepo'],
    }
}
