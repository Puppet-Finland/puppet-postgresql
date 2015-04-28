#
# == Class: postgresql
#
# Install and configure postgresql server
#
# == Parameters
#
# [*manage*]
#  Whether to manage postgresql with Puppet or not. Valid values are 'yes' 
#  (default) and 'no'.
# [*monitor_email*]
#   Email address where local service monitoring software sends it's reports to. 
#   Defaults to global variable $::servermonitor.
# [*backups*]
#   A hash of postgresql::backup resources.
#
# == Examples
#
#    include postgresql
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli.openvpn.net>
#
# Mikko Vilpponen <vilpponen@protecomp.fi>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class postgresql
(
    $manage = 'yes',
    $monitor_email = $::servermonitor,
    $backups = {}
)
{

if $manage == 'yes' {

    create_resources('postgresql::backup', $backups)

    include ::postgresql::install

    # Include the RedHat-specific subclass, if necessary. This approach was 
    # chosen to avoid having to include a dummy Exec["postgresql-initdb"] on 
    # Debian/Ubuntu.
    if $::osfamily == 'RedHat' {
        include ::postgresql::initdb
  }

    include ::postgresql::config
    include ::postgresql::service

    if tagged('monit') {
        class { '::postgresql::monit':
            monitor_email => $monitor_email,
        }
    }
}
}
