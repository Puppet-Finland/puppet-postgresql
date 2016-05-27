#
# == Class: postgresql::monit
#
# Setups monit rules for postgresql
#
class postgresql::monit
(
    $use_latest_release,
    $monitor_email

) inherits postgresql::params
{

    if $use_latest_release {
        $pidfile = $::postgresql::params::latest_pidfile
        $service_start = $::postgresql::params::latest_service_start
        $service_stop = $::postgresql::params::latest_service_stop
    } else {
        $pidfile = $::postgresql::params::pidfile
        $service_start = $::postgresql::params::service_start
        $service_stop = $::postgresql::params::service_stop
    }

    monit::fragment { 'postgresql-postgresql.monit':
        basename   => 'postgresql',
        modulename => 'postgresql',
    }
}
