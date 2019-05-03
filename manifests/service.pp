#
# == Class: pf_postgresql::service
#
# Configures postgresql service to start on boot
#
class pf_postgresql::service
(
    $use_latest_release

) inherits pf_postgresql::params {

    $service_name = $use_latest_release ? {
        true    => $::pf_postgresql::params::latest_service_name,
        false   => $::pf_postgresql::params::service_name,
        default => $::pf_postgresql::params::service_name,
    }

    service { 'postgresql':
        name    => $service_name,
        enable  => true,
        require => Class['pf_postgresql::config'],
    }
}
