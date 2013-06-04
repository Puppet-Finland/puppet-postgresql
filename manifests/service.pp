#
# == Class: postgresql::service
#
# Configures postgresql service to start on boot
#
class postgresql::service {
	service { 'postgresql':
		name => 'postgresql',
		enable => true,
		require => Class['postgresql::config'],
	}
}
