#
# == Class: postgresql::softwarerepo
#
# Set up postgresql apt or yum repositories
#
class postgresql::softwarerepo
(
    $use_latest_release
)
{
    if $use_latest_release {

        case $::osfamily {
            'Debian': {
                include ::postgresql::aptrepo
            }
            default: {
                fail("Unsupported operating system ${::osfamily}")
            }
        }
    }
}