#
# == Define: postgresql::config::auth::file
#
# Setup a basic pg_hba.conf while allowing external modules to add 
# authentication lines to the file. This define works as follows:
#
# 1) The pg_hba.conf.erb template expands contents of postgresql_auth_lines 
#    array into separate lines:
#
#    <% postgresql_auth_lines.each do |line| -%>
#    <%= line %>
#    <% end -%>
#
#    Note that the initial $postgresql_auth_lines array has to be of length 2 or 
#    more or Puppet (in it's stupidity/helpfulness?) will make it a string, 
#    which will wreak havoc in the pg_hba.conf.erb template when the ERB parser 
#    tries to iterate over a string. See postgresql::config::auth for more 
#    details.
#
# 2) The postgresql::config::auth class creates a basic pg_hba.conf using this
#    define. At this point postgresql_auth_lines is empty. The title given to 
#    the define resource ('default-pg_hba.conf') is used by other modules which 
#    need their own authentication lines.
#
# 3) Other modules (e.g. bacula) add content to the postgresql_auth_lines array.
#    They are able to locate the correct resource by it's title, like this:
#
#    Postgresql::Config::Auth::File <| title == 'default-pg_hba.conf' |> {
#        postgresql_auth_lines +> "$postgresql_auth_line",
#    }
#
# This same recipe can be adapted to any templates that need to get content from 
# external modules.
#
# Although assembling configuration file fragments together with an Exec has a 
# similar effect, this approach does not leave unused fragments lying around; in 
# fact, if a service is removed from the node definition, it's pg_hba.conf entry 
# goes away, too.
#
define postgresql::config::auth::file($postgresql_auth_lines) {

    include postgresql::params

    file { 'postgresql-pg_hba.conf':
        name => "$::postgresql::params::data_dir/pg_hba.conf",
        ensure => present,   
        content => template('postgresql/pg_hba.conf.erb'),
        owner => postgres,
        group => postgres,
        mode => 640,
        require => Class['postgresql::install'],
        notify => Class['postgresql::service'],
    }
}
