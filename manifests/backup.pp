#
# == Define: postgresql::backup
#
# Dump PostGreSQL databases to a directory using pg_dump and compress them using 
# gzip. New dumps overwrite the old ones, the idea being that a backup 
# application (e.g. rsnapshot or bacula) fetches the latest local backups at 
# regular intervals and no local versioning is thus necessary.
# 
# This define depends on the 'localbackups' class. Also, the 'postgresql' class 
# has to be included or this define won't be found.
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
#   postgresql::backup { 'trac_database':
#       database => 'trac',
#   }
#
define postgresql::backup
(
    $database = $title,
    $ensure = 'present',
    $output_dir = '/var/backups/local',
    $pg_dump_extra_params = undef,
    $hour = '01',
    $minute = '10',
    $weekday = '*',
    $email = $::servermonitor
)
{

    include ::postgresql::params

    $cron_command = "cd /tmp; sudo -u ${::postgresql::params::daemon_user} pg_dump ${pg_dump_extra_params} ${database}|gzip > \"${output_dir}/${database}-full.sql.gz\""

    # Several other modules will attempt ensure that this same directory exists
    ensure_resource('file', $output_dir, { 'ensure' => 'directory' })

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
        require     => File[$output_dir],
        environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}" ],
    }
}
