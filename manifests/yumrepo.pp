#
# == Class: pf_postgresql::yumrepo
#
# Enable postgresql's official yum repositories. Adapted from 
# puppetlabs/postgresql's postgresql::repo::yum_postgresql_org class.
#
class pf_postgresql::yumrepo inherits pf_postgresql::params {

    $latest_release = $::pf_postgresql::params::latest_release

    $gpg_key_path = "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-${latest_release}"

    file { $gpg_key_path:
      source => 'puppet:///modules/postgresql/RPM-GPG-KEY-PGDG',
      before => Yumrepo['yum.postgresql.org']
    }

    if $::operatingsystem == 'Fedora' {
      $label1 = 'fedora'
      $label2 = $label1
    } else {
      $label1 = 'redhat'
      $label2 = 'rhel'
    }

    yumrepo { 'yum.postgresql.org':
      descr    => "PostgreSQL ${::pf_postgresql::params::latest_release} \$releasever - \$basearch",
      baseurl  => "http://yum.postgresql.org/${latest_release}/${label1}/${label2}-\$releasever-\$basearch",
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => "file://${gpg_key_path}",
    }
}


