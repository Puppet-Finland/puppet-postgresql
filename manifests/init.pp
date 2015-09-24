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
# [*use_latest_release*]
#   Whether to use the latest postgresql version from postgresql softaware 
#   repositories. Valid values are true and false (default).
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
    $use_latest_release = false,
    $monitor_email = $::servermonitor,
    $backups = {}
)
{

if $manage == 'yes' {

    class { '::postgresql::softwarerepo':
        use_latest_release => $use_latest_release,
    }

    class { '::postgresql::install':
        use_latest_release => $use_latest_release,
    }

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

    create_resources('postgresql::backup', $backups)
}
}
