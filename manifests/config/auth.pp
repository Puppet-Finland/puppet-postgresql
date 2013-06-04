#
# == Class: postgresql::config::auth
#
# This class setups a default pg_hba.conf. It's name ('default-pg_hba.conf') is 
# used to refer to it from outside this module, when adding per-service 
# authentication lines (e.g. for bacula).
#
class postgresql::config::auth {
    postgresql::config::auth::file { 'default-pg_hba.conf': }
}
