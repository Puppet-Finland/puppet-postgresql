#
# == Class: postgresql::config::auth
#
# This class setups a default pg_hba.conf. It's name ('default-pg_hba.conf') is 
# used to refer to it from outside this module, when adding per-service 
# authentication lines (e.g. for bacula).
#
# NOTE: The silly $postgresql_auth_lines value is passed on because Puppet seems 
# to convert arrays with length of one (or zero?) into strings. This means that 
# the ERB parser will fail while trying to iterate over a string. Therefore we 
# need to ensure the ERB parser really gets an array, and the only way to do 
# that is to create $postgresql_auth_lines as such, no matter how many times 
# content is added to it. A less hacky approach would be most welcome...
#
class postgresql::config::auth {
    postgresql::config::auth::file { 'default-pg_hba.conf':
        postgresql_auth_lines => ['', '']
    }
}
