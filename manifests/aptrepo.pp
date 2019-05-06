#
# == Class: pf_postgresql::aptrepo
#
# Enable postgresql's official apt repositories. Adapted from 
# postgresql::repo::apt_postgresql_org
#
class pf_postgresql::aptrepo inherits pf_postgresql::params {

    include ::apt

    # Here we have tried to replicate the instructions on the PostgreSQL site:
    #
    # http://www.postgresql.org/download/linux/debian/
    #
    apt::source { 'apt.postgresql.org':
      location    => 'http://apt.postgresql.org/pub/repos/apt/',
      release     => "${::lsbdistcodename}-pgdg",
      repos       => 'main',
      key         => 'B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8',
      key_source  => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
      include_src => false,
    }

    apt::pin { 'apt_postgresql_org':
        originator => 'apt.postgresql.org',
        priority   => 500,
        require    => Apt::Source['apt.postgresql.org'],
    }
}
