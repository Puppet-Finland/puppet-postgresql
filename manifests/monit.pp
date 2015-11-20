#
# == Class: postgresql::monit
#
# Setups monit rules for postgresql
#
class postgresql::monit
(
    $use_latest_release,
    $monitor_email
)
{

    $pidfile = $use_latest_release ? {
        true    => $::postgresql::params::latest_pidfile,
        false   => $::postgresql::params::pidfile,
        default => $::postgresql::params::pidfile,
    }

    monit::fragment { 'postgresql-postgresql.monit':
        basename   => 'postgresql',
        modulename => 'postgresql',
    }
}
