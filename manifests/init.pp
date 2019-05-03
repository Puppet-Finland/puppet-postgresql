#
# == Class: pf_postgresql
#
# Install and configure postgresql server
#
# == Parameters
#
# [*manage*]
#   Whether to manage postgresql with Puppet or not. Valid values are true
#   (default) and false.
# [*manage_monit*]
#   Monitor postgresql with monit. Valid values are true (default) and false.
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
#    include pf_postgresql
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
class pf_postgresql
(
    Boolean $manage = true,
    Boolean $manage_monit = true,
    Boolean $use_latest_release = false,
    String  $monitor_email = $::servermonitor,
    Hash    $backups = {}
)
{

if $manage {

    class { '::pf_postgresql::softwarerepo':
        use_latest_release => $use_latest_release,
    }

    class { '::pf_postgresql::install':
        use_latest_release => $use_latest_release,
    }

    # Include the RedHat-specific subclass, if necessary. This approach was 
    # chosen to avoid having to include a dummy Exec["postgresql-initdb"] on 
    # Debian/Ubuntu.
    if $::osfamily == 'RedHat' {
        class { '::pf_postgresql::initdb':
            use_latest_release => $use_latest_release,
        }
    }

    include ::pf_postgresql::config

    class { '::pf_postgresql::service':
        use_latest_release => $use_latest_release,
    }

    if $manage_monit {
        class { '::pf_postgresql::monit':
            use_latest_release => $use_latest_release,
            monitor_email      => $monitor_email,
        }
    }

    create_resources('pf_postgresql::backup', $backups)
}
}
