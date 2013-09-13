#
# == Class: postgresql
#
# Install and configure postgresql server
#
# == Parameters
#
# None at the moment
#
# == Examples
#
# include postgresql
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli.openvpn.net>
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
# 
class postgresql {

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_postgresql', 'true') != 'false' {

    include postgresql::install

    # Include the RedHat-specific subclass, if necessary. This approach was 
    # chosen to avoid having to include a dummy Exec["postgresql-initdb"] on 
    # Debian/Ubuntu.
    if $::osfamily == 'RedHat' {
        include postgresql::initdb
	}

    include postgresql::config
    include postgresql::service

    if tagged('monit') {
        include postgresql::monit
    }
}
}
