#
# == Class: postgresql::config
#
# Configure postgresql. Currently this class does nothing, but in the past it
# included postgresql::config::auth class, which used a fancy array-appending
# trick to realize several postgresql auth lines originating from various other
# Puppet modules. This neat trick was historically a bit fragile, so now
# the other modules (e.g. bacula, trac) use Augeas to setup postgresql
# authentication lines. Example:
#
#   augeas { 'bacula-director-pg_hba.conf':
#       context => '/files/etc/postgresql/9.3/main/pg_hba.conf',
#       changes => [
#           "ins 0434 after 1",
#           "set 0434/type local",
#           "set 0434/database bacula",
#           "set 0434/user baculauser",
#           "set 0434/method password"
#       ],
#       lens => 'Pg_hba.lns',
#       incl => '/etc/postgresql/9.3/main/pg_hba.conf',
#       # Without "onlyif" every Puppet run would generate a new authentication
#       # line to pg_hba.conf.
#       onlyif => "match *[user = 'baculauser'] size == 0",
#   }
#
# The augeas syntax above was adapted from here:
#
# <http://perlstalker.vuser.org/blog/2012/08/28/managing-etc-hosts-with-puppet>
#
# For more details on use of Augeas look here:
#
# <http://augeas.net/docs/references/lenses/files/pg_hba-aug.html>
# <http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas>
# <https://docs.puppetlabs.com/guides/augeas.html>
# <https://github.com/hercules-team/augeas/wiki/Path-expressions>
#
# Textual identifiers don't seem to work with Augeas. Using a semi-random
# numeric identifier - like 0434 above - is probably the safest bet to avoid
# identifier collisions.
#
class postgresql::config {
    # Empty
}
