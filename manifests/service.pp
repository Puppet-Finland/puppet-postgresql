#
# == Class: postgresql::service
#
# Configures postgresql service to start on boot
#
class postgresql::service
(
    $use_latest_release

) inherits postgresql::params {

    $service_name = $use_latest_release ? {
        true    => $::postgresql::params::latest_service_name,
        false   => $::postgresql::params::service_name,
        default => $::postgresql::params::service_name,
    }

    service { 'postgresql':
        name    => $service_name,
        enable  => true,
        require => Class['postgresql::config'],
    }
}
