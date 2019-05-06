#
# == Class: pf_postgresql::softwarerepo
#
# Set up postgresql apt or yum repositories
#
class pf_postgresql::softwarerepo
(
    $use_latest_release
)
{
    if $use_latest_release {

        case $::osfamily {
            'Debian': {
                include ::pf_postgresql::aptrepo
            }
            'RedHat': {
                include ::pf_postgresql::yumrepo
            }
            default: {
                fail("Unsupported operating system ${::osfamily}")
            }
        }
    }
}
