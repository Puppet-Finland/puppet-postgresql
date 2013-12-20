#
# == Class: postgresql::monit
#
# Setups monit rules for postgresql
#
class postgresql::monit
(
    $monitor_email
)
{
	monit::fragment { 'postgresql-postgresql.monit':
		modulename => 'postgresql',
	}
}
