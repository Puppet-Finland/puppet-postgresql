#
# == Define: postgresql::loadsql
#
# Load an SQL file using pgsql. Useful for things like creating users and 
# databases. The convention is to place the SQL files to the postgres 
# configuration directory. As they may contain sensitive information, they have 
# very limited permissions.
#
# == Parameters
#
# [*basename*]
#   Name of the template file containing the SQL commands
# [*modulename*]
#   Name of the Puppet module where the template is located. Defaults to
#   $basename.
#
# == Examples
#
# postgresql::loadsql { 'bacula-bacula-director.sql':
#   modulename => 'bacula',
#   basename => 'bacula-director',
# }
#
define postgresql::loadsql
(
    $basename,
    $modulename=$basename
)
{
    file { "postgresql-${basename}.sql":
        name => "${::postgresql::params::data_dir}/${basename}.sql",
        content => template("${modulename}/${basename}.sql.erb"),
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        # FIXME: this does not work as expected, i.e. tries to place the SQL 
        # file _before_ the proper data directory is present.
        require => Class['postgresql'],
    }

    exec { "postgresql-load-${basename}.sql":
        command => "psql --file ${::postgresql::params::data_dir}/${basename}.sql",
        # The 'postgres' user has fairly limited access to the filesystem, so we 
        # 'cd /tmp' to avoid getting false return values.
        cwd => '/tmp',
        path => [ '/usr/bin', '/usr/local/bin' ],
        user => 'postgres',
        require => File["postgresql-${basename}.sql"],
        subscribe => File["postgresql-${basename}.sql"],
        refreshonly => true,
    }
}
