#
# == Class: postgresql::monit
#
# Setups monit rules for postgresql
#
class postgresql::monit {

	monit::fragment { 'postgresql-postgresql.monit':
		modulename => 'postgresql',
	}
}
