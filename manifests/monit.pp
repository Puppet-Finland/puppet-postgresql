#
# == Class: pf_postgresql::monit
#
# Setups monit rules for postgresql
#
class pf_postgresql::monit
(
    $use_latest_release,
    $monitor_email

) inherits pf_postgresql::params
{

    if $use_latest_release {
        $pidfile = $::pf_postgresql::params::latest_pidfile
        $service_start = $::pf_postgresql::params::latest_service_start
        $service_stop = $::pf_postgresql::params::latest_service_stop
    } else {
        $pidfile = $::pf_postgresql::params::pidfile
        $service_start = $::pf_postgresql::params::service_start
        $service_stop = $::pf_postgresql::params::service_stop
    }

    monit::fragment { 'postgresql-postgresql.monit':
        basename   => 'postgresql',
        modulename => 'postgresql',
    }
}
