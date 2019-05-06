#
# == Define: pf_postgresql::loadsql
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
define pf_postgresql::loadsql
(
    String $basename,
    String $modulename=$basename
)
{
    file { "postgresql-${basename}.sql":
        ensure  => present,
        name    => "${::pf_postgresql::params::data_dir}/${basename}.sql",
        content => template("${modulename}/${basename}.sql.erb"),
        owner   => postgres,
        group   => postgres,
        mode    => '0600',
        # FIXME: this does not work as expected, i.e. tries to place the SQL 
        # file _before_ the proper data directory is present.
        require => Class['pf_postgresql'],
    }

    exec { "postgresql-load-${basename}.sql":
        command     => "psql --file ${::pf_postgresql::params::data_dir}/${basename}.sql",
        # The 'postgres' user has fairly limited access to the filesystem, so we 
        # 'cd /tmp' to avoid getting false return values.
        cwd         => '/tmp',
        path        => [ '/usr/bin', '/usr/local/bin' ],
        user        => 'postgres',
        require     => File["postgresql-${basename}.sql"],
        subscribe   => File["postgresql-${basename}.sql"],
        refreshonly => true,
    }
}
