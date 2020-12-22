#
# == Define: pf_postgresql::backup
#
# Dump PostGreSQL databases to a directory using pg_dump and compress them using 
# gzip. New dumps overwrite the old ones, the idea being that a backup 
# application (e.g. rsnapshot or bacula) fetches the latest local backups at 
# regular intervals and no local versioning is thus necessary.
# 
# == Parameters
#
# [*database*]
#   The database to back up. Defaults to the resource $title.
# [*ensure*]
#   Status of the backup job. Either 'present' or 'absent'. Defaults to 
#   'present'.
# [*pg_dump*]
#   Path to pg_dump. Defaults to 'pg_dump'.
# [*output_dir*]
#   The directory where to output the files. Defaults to /var/backups/local.
# [*pg_dump_extra_params*]
#   Extra parameters to pass to pg_dump.
# [*hour*]
#   Hour(s) when postgresql gets run. Defaults to 01.
# [*minute*]
#   Minute(s) when postgresql gets run. Defaults to 10.
# [*weekday*]
#   Weekday(s) when postgresql gets run. Defaults to * (all weekdays).
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
#
# == Examples
#
#   pf_postgresql::backup { 'trac_database':
#       database => 'trac',
#   }
#
define pf_postgresql::backup
(
    String                                                              $database = $title,
    Enum['present','absent']                                            $ensure = 'present',
    String                                                              $output_dir = '/var/backups/local',
    Optional[String]                                                    $pg_dump = 'pg_dump',
    Optional[String]                                                    $pg_dump_extra_params = undef,
    Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour = '01',
    Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute = '10',
    Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday = '*',
    String                                                              $email = $::servermonitor,
    Optional[String]                                                    $host = undef,
    Optional[String]                                                    $username = undef,
    Optional[String]                                                    $pgpassword = undef,
)
{

    include ::pf_postgresql::params

    # User, host and PGPASSWORD are generally only needed when taking backups
    # from a remote serversuch as RDS
    $username_opt = $username ? {
      undef   => '',
      default => "-U ${username}",
    }

    # We don't need sudo if we're backing up a remote database
    if $host {
      $host_opt =  "-h ${host}"
      $sudo_opt = ''
    } else {
      $host_opt = ''
      $sudo_opt = "sudo -u ${::pf_postgresql::params::daemon_user}"
    }

    $base_env = ['PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}"]

    if $pgpassword {
      $cron_env = ["PGPASSWORD=${pgpassword}"] + $base_env
    } else {
      $cron_env = $base_env
    }

    $cron_command = "cd /tmp; ${sudo_opt} ${pg_dump} ${pg_dump_extra_params} ${host_opt} ${username_opt} ${database}|gzip > \"${output_dir}/${database}-full.sql.gz\"" # lint:ignore:140chars

    cron { "postgresql-backup-${database}-cron":
        ensure      => $ensure,
        command     => $cron_command,
        user        => root,
        hour        => $hour,
        minute      => $minute,
        weekday     => $weekday,
        # Technically speaking this cronjob depends also on postgresql::install. 
        # However, the cronjob will fail not only when pg_dump is not installed, 
        # but also if the defined database has not been created when the cronjob 
        # runs. 
        environment => $cron_env,
    }
}
