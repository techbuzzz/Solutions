# Description

This resource is used to configure a timer job and make sure it is in a
specific state. The resource can be used to enable or disabled the job and
configure the schedule of the job.

The schedule parameter has to be written in the SPSchedule format
(https://technet.microsoft.com/en-us/library/ff607916.aspx).

Examples are:

- Every 5 minutes between 0 and 59
- Hourly between 0 and 59
- Daily at 15:00:00
- Weekly between Fri 22:00:00 and Sun 06:00:00
- Monthly at 15 15:00:00
- Yearly at Jan 1 15:00:00

NOTE: Make sure you use the internal timer job name, not the display name! Use
"Get-SPTimerJob -WebApplication "http://servername" | select Name, DisplayName"
to find the internal name for each Timer Job.
