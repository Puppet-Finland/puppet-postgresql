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
    Optional[String]                                                    $pg_dump_extra_params = undef,
    Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour = '01',
    Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute = '10',
    Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday = '*',
    String                                                              $email = $::servermonitor
)
{

    include ::pf_postgresql::params

    $cron_command = "cd /tmp; sudo -u ${::pf_postgresql::params::daemon_user} pg_dump ${pg_dump_extra_params} ${database}|gzip > \"${output_dir}/${database}-full.sql.gz\""

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
        environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}" ],
    }
}
