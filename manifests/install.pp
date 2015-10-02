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
        true    => $::postgresql::params::latest_package_name,
        false   => $::postgresql::params::package_name,
        default => $::postgresql::params::package_name,
    }

    package { 'postgresql-postgresql-server':
        ensure  => installed,
        name    => $package_name,
        require => Class['postgresql::softwarerepo'],
    }
}
