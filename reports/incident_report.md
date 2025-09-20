# ticket 002

This task is to investigate the root cause by analyzing EC2 error logs and documentation my findings.

due to this is a role-play, i first create a EC2 instance name "dev-app-server-01" in aws

i have created a EC2 and install apache so it will become a web server, in this process, i learnt how to use IAM access key, use CLI to install httpd, and set security group inbound rule to allow port 80 http so i can connect to the server, also how to use curl to test if the server is working or not. After that, i also try to deploy a simple static web app to EC2 and clone the github repo to the web server, so when i go to browser and open the public ipv4 address , it will show my static web app.

even i create the EC2 but i cannot get a real error log, so i ask AI to create some real world error log for different situation so i can work on it, below are the error log from different senerio and my incident report. 

to find error log from EC2, i  go to the console, click Action -> monitor and troubleshoot --> get system log.

to find error log from Cloudwatch, i go to the Cloudwatch , click Log Group to view and filter the log. 

i have also learnt:
 - for immediatly access to boot log, i should view ec2 Get System Log.
 - for on going monitor, i should view CloudWatch - Log Group - error log and metric.
 
 -------------------------------------------------------------------------
 
 by the way, if i want EC2 instance to send log to CloudWatch, i have to install CloudWatch Agent to EC2 instance:
  - first i will SSH to the EC2 instance
  - then i install CloudWatch Agent by CLI:
  
           $ sudo yum update -y 
		   $ sudo yum install -y amazon-cloudwatch-agent
		   $ sudo systemctl start amazon-cloudwatch-agent
		   $ sudo systemctl enable amazon-cloudwatch-agent
		   
		   also, i have to update the IAM policy to make sure EC2 have IAM role with permission to write log to CloudWatch:

						{
						  "Effect": "Allow",
						  "Action": [
							"logs:CreateLogGroup",
							"logs:CreateLogStream",
							"logs:PutLogEvents"
						  ],
						  "Resource": "*"
						}
 
------------------------------------------------------------------------------

# Error log generate by AI from different senerio and my incident report: 


## 1. Out of Memory (OOM) Errors
```yaml

kernel: [123456.789012] Out of memory: Kill process 1234 (java) score 567 or sacrifice child
kernel: [123456.789015] Killed process 1234 (java) total-vm:123456kB, anon-rss:23456kB, file-rss:34567kB
kernel: [123456.789020] Memory cgroup out of memory: Kill process 5678 (node) score 600 or sacrifice child
kernel: [123456.789022] Killed process 5678 (node) total-vm:654321kB, anon-rss:45678kB, file-rss:56789kB
kernel: [123456.789030] Memory cgroup out of memory: Failed to allocate memory for task
kernel: [123456.789035] Node 0: lowmem-reserved: 0 pages
kernel: [123456.789040] Node 0: 123456 pages in use
kernel: [123456.789045] Node 0: 123456 pages free
kernel: [123456.789050] Node 0: 123456 pages dirty
kernel: [123456.789055] Node 0: 123456 pages slab
kernel: [123456.789060] Node 0: 123456 pages mapped
kernel: [123456.789065] Out of memory: No killable processes left
kernel: [123456.789070] Kernel panic - not syncing: Out of memory
kernel: [123456.789075] Panic occurred, switching back to text console
kernel: [123456.789080] Kernel Offset: 0x0 from 0xffffffff81000000
kernel: [123456.789085] Rebooting in 5 seconds...
```
########################################################

## Incident Report: Out of Memory (OOM) Error


1. Incident Overview
Date/Time of Incident: [Insert date and time]
Affected System: [Specify the affected EC2 instance or service]
Incident Severity: High
Reported By: Cari


2. Incident Description
On [insert date], an Out of Memory (OOM) error occurred on the [specify instance/service]. This led to the termination of critical processes, including Java and Node applications, resulting in service disruption.


3. Error Logs
Relevant logs indicating the OOM error:
```sql_more

kernel: [123456.789012] Out of memory: Kill process 1234 (java) score 567 or sacrifice child
kernel: [123456.789015] Killed process 1234 (java) total-vm:123456kB, anon-rss:23456kB, file-rss:34567kB
kernel: [123456.789020] Memory cgroup out of memory: Kill process 5678 (node) score 600 or sacrifice child
kernel: [123456.789022] Killed process 5678 (node) total-vm:654321kB, anon-rss:45678kB, file-rss:56789kB
kernel: [123456.789065] Out of memory: No killable processes left
kernel: [123456.789070] Kernel panic - not syncing: Out of memory
kernel: [123456.789075] Panic occurred, switching back to text console
```

4. Root Cause Analysis

Cause of OOM Error:
The system ran out of available memory, leading the kernel to terminate processes to reclaim memory. Critical applications, including Java and Node, were killed due to high memory usage.

Contributing Factors:
Inefficient memory management in the applications.
Insufficient instance type for the workload.
Lack of monitoring alerts for memory usage.


5. Impact Assessment
Affected Services: Java and Node applications on the affected EC2 instance.
Duration of Impact: [Specify how long the services were affected]
User Impact: Users experienced service unavailability and degraded performance during the incident.


6. Resolution Steps

Immediate Actions Taken:
The affected instance was restarted to recover from the kernel panic.
Increased the instance type to provide more memory.

Long-term Actions:
Implemented application performance monitoring to track memory usage.
Optimized code to reduce memory consumption.
Set up CloudWatch alarms to alert on high memory usage.


7. Lessons Learned
Regular monitoring and alerting for memory usage are crucial to prevent future incidents.
Application optimization can significantly reduce memory footprint.
Consider auto-scaling or resource provisioning strategies to handle peak loads.


8. Next Steps
Conduct a review of the application’s memory usage patterns.
Schedule a follow-up meeting to discuss long-term optimizations and monitoring enhancements.


9. Attachments
[Include relevant documents, charts, or additional logs that support the report.]



------------------------------------------------------------------------------

## 2. Disk Space Full
```pgsql

df: /: no space left on device
systemd[1]: Failed to start MySQL Database Server.
mysql[12345]: [ERROR] Can't create/write to file '/var/lib/mysql/mysql.sock' (Errcode: 28 "No space left on device")
systemd[1]: mysql.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: mysql.service: Failed with result 'exit-code'.
systemd[1]: Failed to start MySQL Database Server.
systemd[1]: Starting MySQL Database Server...
systemd[1]: Starting Apache HTTP Server...
apache2[12346]: [AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
apache2[12346]: [ERROR] No space left on device: /var/log/apache2/error.log
systemd[1]: apache2.service: Failed with result 'exit-code'.
systemd[1]: Failed to start Apache HTTP Server.
systemd[1]: Starting systemd-resolved.service...
systemd[1]: systemd-resolved.service: Failed to start.
systemd[1]: systemd-resolved.service: Failed with result 'exit-code'.
systemd[1]: Starting cron.service...
systemd[1]: cron.service: Failed to start.
systemd[1]: cron.service: Failed with result 'exit-code'.
```
#############################################################


## Incident Report: Disk Space Full


1. Incident Overview
Date/Time of Incident: [Insert date and time]
Affected System: [Specify the affected server or service]
Incident Severity: High
Reported By: Cari


2. Incident Description
On [insert date], the system encountered a "Disk Space Full" error, which prevented critical services from starting. This issue affected both the MySQL Database Server and the Apache HTTP Server, leading to service disruptions.


3. Error Logs
Relevant logs indicating the disk space issue:
```json

df: /: no space left on device
systemd[1]: Failed to start MySQL Database Server.
mysql[12345]: [ERROR] Can't create/write to file '/var/lib/mysql/mysql.sock' (Errcode: 28 "No space left on device")
systemd[1]: mysql.service: Main process exited, code=exited, status=1/FAILURE
systemd[1]: Failed to start MySQL Database Server.
systemd[1]: Starting Apache HTTP Server...
apache2[12346]: [ERROR] No space left on device: /var/log/apache2/error.log
systemd[1]: apache2.service: Failed with result 'exit-code'.
```

4. Root Cause Analysis

Cause of Disk Space Full Error:
The root cause was insufficient disk space on the server, which led to the inability to write necessary files for the MySQL and Apache services.

Contributing Factors:
Accumulation of log files without proper rotation or cleanup.
Potentially large database files that were not managed effectively.
Lack of monitoring alerts for disk usage.


5. Impact Assessment
Affected Services: MySQL Database Server and Apache HTTP Server.
Duration of Impact: [Specify how long the services were affected]
User Impact: Users experienced service unavailability and degraded performance as both the database and web server were unable to start.


6. Resolution Steps

Immediate Actions Taken:
Cleared unnecessary log files and temporary files to free up disk space.
Restarted the MySQL and Apache services once sufficient space was available.

Long-term Actions:
Implemented log rotation to prevent log files from consuming all available disk space.
Set up monitoring and alerts for disk usage to proactively manage storage.


7. Lessons Learned
Regular monitoring and alerting for disk space usage are crucial to prevent service disruptions.
Implementing automated log rotation and cleanup strategies can mitigate similar issues.
Regular audits of disk usage and database size should be conducted.


8. Next Steps
Schedule a follow-up meeting to review disk usage and monitoring strategies.
Consider increasing the disk size or implementing auto-scaling options based on usage patterns.


9. Attachments
[Include relevant documents, charts, or additional logs that support the report.]


------------------------------------------------------------------------------



## 3. Failed User Data Script
```json

cloud-init[123]: Cloud-init v. 20.4 running 'modules:final' at Tue, 16 Jul 2025 12:00:00 +0000. Up 15.09 seconds.
cloud-init[123]: /var/lib/cloud/instance/scripts/part-001: line 10: apt-get: command not found
cloud-init[123]: /var/lib/cloud/instance/scripts/part-001: line 12: curl: command not found
cloud-init[123]: [ERROR] Failed to run user data script.
cloud-init[123]: Cloud-init failed with error: Command failed with exit code 127.
cloud-init[123]: Running cloud-init modules: final
cloud-init[124]: Starting cloud-init-local.service...
cloud-init[124]: cloud-init-local.service: Main process exited, code=exited, status=1/FAILURE
cloud-init[124]: Running cloud-init modules: final
cloud-init[124]: Cloud-init finished with errors.
cloud-init[125]: No further information available.
systemd[1]: cloud-init.service: Failed with result 'exit-code'.
systemd[1]: cloud-init.service: Start request repeated too quickly.
systemd[1]: Failed to start Cloud-init service.
systemd[1]: Starting cloud-init.service...
systemd[1]: Starting cloud-init.service: Start request repeated too quickly.
systemd[1]: Failed to start Cloud-init service.
systemd[1]: cloud-init.service: Failed with result 'exit-code'.
```

##########################################################################

## Incident Report: Failed User Data Script

1. Incident Overview
Date/Time of Incident: July 16, 2025, 12:00 PM UTC
Affected System: [Specify the affected EC2 instance or service]
Incident Severity: Medium
Reported By: Cari


2. Incident Description
On July 16, 2025, the cloud-init process encountered an error while executing the user data script, resulting in a failure to install necessary packages. This disruption affected the initialization of the EC2 instance.


3. Error Logs
Relevant logs indicating the failure:
```awk

cloud-init[123]: Cloud-init v. 20.4 running 'modules:final' at Tue, 16 Jul 2025 12:00:00 +0000. Up 15.09 seconds.
cloud-init[123]: /var/lib/cloud/instance/scripts/part-001: line 10: apt-get: command not found
cloud-init[123]: /var/lib/cloud/instance/scripts/part-001: line 12: curl: command not found
cloud-init[123]: [ERROR] Failed to run user data script.
cloud-init[123]: Cloud-init failed with error: Command failed with exit code 127.
cloud-init[124]: cloud-init.service: Failed with result 'exit-code'.
```

4. Root Cause Analysis

Cause of Failure:
The user data script failed because it attempted to use commands (apt-get and curl) that were not available in the base image used for the EC2 instance. This resulted in the cloud-init process failing to complete the instance initialization.

Contributing Factors:
The base AMI used did not include the necessary package manager or utilities.
Lack of error handling in the user data script to check for command availability.


5. Impact Assessment
Affected Services: Initialization of the EC2 instance.
Duration of Impact: The instance remained in a failed state until the issue was resolved.
User Impact: Users experienced delays in accessing the services hosted on this EC2 instance.


6. Resolution Steps

Immediate Actions Taken:
Reviewed and modified the user data script to include checks for command availability before execution.
Launched a new instance with a different base AMI that contains the required packages.

Long-term Actions:
Implemented a standardized process for user data scripts to ensure compatibility with the selected AMI.
Enhanced documentation and testing procedures for user data scripts to avoid similar issues in the future.


7. Lessons Learned
Always verify the compatibility of user data scripts with the chosen AMI.
Implement error handling in scripts to gracefully handle missing commands or dependencies.
Regularly review and test user data scripts as part of the deployment process.


8. Next Steps
Schedule a review of all existing user data scripts to ensure they are robust and compatible with current AMIs.
Conduct a training session for team members on best practices for writing user data scripts.


9. Attachments
[Include relevant documents, updated scripts, or additional logs that support the report.]


------------------------------------------------------------------------------

## 4. Kernel Panic
```json

kernel: [123456.789000] Kernel panic - not syncing: Fatal exception in interrupt
kernel: [123456.789001] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-42-generic #46-Ubuntu
kernel: [123456.789002] Hardware name: Amazon EC2 T2.micro/EC2, BIOS 1.0 09/17/2019
kernel: [123456.789003] Call Trace:
kernel: [123456.789004] dump_stack+0x6d/0x8d
kernel: [123456.789005] panic+0xe0/0x2b8
kernel: [123456.789006] __handle_irq_event+0x3c/0x90
kernel: [123456.789007] handle_irq_event_percpu+0x3a/0x50
kernel: [123456.789008] handle_irq_event+0x3e/0x50
kernel: [123456.789009] __handle_irq+0x2e/0x70
kernel: [123456.789010] do_IRQ+0x3f/0x130
kernel: [123456.789011] common_interrupt+0xf/0xf
kernel: [123456.789012] <IRQ>
kernel: [123456.789013] [<c0000000>] 0x0
kernel: [123456.789014] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
kernel: [123456.789015] Kernel Offset: 0x0 from 0xffffffff81000000
kernel: [123456.789016] Rebooting in 5 seconds...
```

##########################################################################

## Incident Report: Kernel Panic

1. Incident Overview
Incident ID: [Unique Identifier]
Date: [Date of the Incident]
Time: [Time of the Incident]
Reported by: Cari
Affected Instance: EC2 T2.micro
Operating System: Ubuntu 5.4.0-42-generic

2. Description
On [date], at approximately [time], a kernel panic occurred on the EC2 T2.micro instance running Ubuntu. The system halted due to a fatal exception in an interrupt, resulting in an inability to continue processing.

3. Error Log
```plaintext
kernel: [123456.789000] Kernel panic - not syncing: Fatal exception in interrupt
kernel: [123456.789001] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-42-generic #46-Ubuntu
kernel: [123456.789002] Hardware name: Amazon EC2 T2.micro/EC2, BIOS 1.0 09/17/2019
kernel: [123456.789003] Call Trace:
kernel: [123456.789004] dump_stack+0x6d/0x8d
kernel: [123456.789005] panic+0xe0/0x2b8
kernel: [123456.789006] __handle_irq_event+0x3c/0x90
kernel: [123456.789007] handle_irq_event_percpu+0x3a/0x50
kernel: [123456.789008] handle_irq_event+0x3e/0x50
kernel: [123456.789009] __handle_irq+0x2e/0x70
kernel: [123456.789010] do_IRQ+0x3f/0x130
kernel: [123456.789011] common_interrupt+0xf/0xf
kernel: [123456.789012] <IRQ>
kernel: [123456.789013] [<c0000000>] 0x0
kernel: [123456.789014] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
kernel: [123456.789015] Kernel Offset: 0x0 from 0xffffffff81000000
kernel: [123456.789016] Rebooting in 5 seconds...
```

4. Analysis
The kernel panic was triggered by a fatal exception in an interrupt, which indicates an issue at the kernel level. The call trace suggests that the panic originated from the interrupt handling routine.


5. Potential Causes
Hardware Issues: Faulty memory or CPU could lead to kernel panics.
Software Bugs: Issues in the kernel or device drivers may also cause such failures.
Resource Constraints: The T2.micro instance may have been under heavy load, leading to resource exhaustion.


6. Impact
The instance became unresponsive and required a manual restart.
Any applications or services running on the instance were temporarily unavailable.


7. Resolution Steps
Reboot the Instance: The instance was rebooted after the panic.
Monitoring: Increased monitoring to track any further occurrences of kernel panics.
Logs Review: Reviewed system logs for any additional errors leading up to the panic.


8. Recommendations
Upgrade Instance Type: Consider upgrading to a larger instance type if resource constraints are suspected.
Kernel Updates: Ensure that the instance is running the latest kernel version to incorporate any bug fixes or improvements.
Regular Backups: Maintain regular backups to minimize data loss in the event of future incidents.


9. Conclusion
The kernel panic incident was resolved by rebooting the instance. Further monitoring and analysis are required to determine the underlying cause and prevent recurrence.





------------------------------------------------------------------------------

## 5. Mounting Issues
```sql_more

systemd[1]: Mounting /mnt/ebs_volume...
systemd[1]: mnt-ebs_volume.mount: Mount process finished, but there is no mount point defined.
systemd[1]: mnt-ebs_volume.mount: Failed with result 'exit-code'.
systemd[1]: Failed to mount /mnt/ebs_volume.
systemd[1]: Starting my_service.service...
my_service[12345]: [ERROR] Failed to start service: Unable to access /mnt/ebs_volume
systemd[1]: my_service.service: Failed with result 'exit-code'.
systemd[1]: Starting my_other_service.service...
my_other_service[12346]: [ERROR] Configuration file not found for service.
systemd[1]: my_other_service.service: Failed to start.
systemd[1]: Starting cron.service...
systemd[1]: cron.service: Failed to start.
systemd[1]: cron.service: Failed with result 'exit-code'.
systemd[1]: Starting httpd.service...
httpd[12347]: [ERROR] Cannot open the document root directory /mnt/ebs_volume/www: No such file or directory
httpd[12347]: [ERROR] httpd: Configuration error on line 120 of /etc/httpd/conf/httpd.conf: DocumentRoot '/mnt/ebs_volume/www' not found
systemd[1]: httpd.service: Failed with result 'exit-code'.
These logs provide a glimpse into various error scenarios you might encounter with an EC2 instance. They can help you understand the types of issues that can arise and how they might be logged.
```

##########################################################################


## Incident Report: Mounting Issue

1. Incident Overview
Incident ID: [Unique Identifier]
Date: [Date of the Incident]
Time: [Time of the Incident]
Reported by: Cari
Affected Instance: [Instance ID/Name]
Operating System: [OS Version]


2. Description
On [date], at approximately [time], a mounting issue was detected on the instance. The system failed to mount the specified EBS volume, leading to multiple service failures.


3. Error Log
```plaintext
systemd[1]: Mounting /mnt/ebs_volume...
systemd[1]: mnt-ebs_volume.mount: Mount process finished, but there is no mount point defined.
systemd[1]: mnt-ebs_volume.mount: Failed with result 'exit-code'.
systemd[1]: Failed to mount /mnt/ebs_volume.
systemd[1]: Starting my_service.service...
my_service[12345]: [ERROR] Failed to start service: Unable to access /mnt/ebs_volume
systemd[1]: my_service.service: Failed with result 'exit-code'.
systemd[1]: Starting my_other_service.service...
my_other_service[12346]: [ERROR] Configuration file not found for service.
systemd[1]: my_other_service.service: Failed to start.
systemd[1]: Starting cron.service...
systemd[1]: cron.service: Failed to start.
systemd[1]: cron.service: Failed with result 'exit-code'.
systemd[1]: Starting httpd.service...
httpd[12347]: [ERROR] Cannot open the document root directory /mnt/ebs_volume/www: No such file or directory
httpd[12347]: [ERROR] httpd: Configuration error on line 120 of /etc/httpd/conf/httpd.conf: DocumentRoot '/mnt/ebs_volume/www' not found
systemd[1]: httpd.service: Failed with result 'exit-code'.
```

4. Analysis
The mounting issue was caused by the system's failure to define the mount point for the specified EBS volume, resulting in multiple service failures due to the inability to access necessary files.


5. Potential Causes
Undefined Mount Point: The specified mount point /mnt/ebs_volume was not defined or created prior to the mount attempt.
Configuration Errors: Services that depend on the mounted volume could not start due to missing files or directories.
Service Dependencies: Services were attempting to start before the EBS volume was successfully mounted.


6. Impact
Several critical services failed to start, including:
my_service
my_other_service
cron
httpd
Users experienced downtime for applications reliant on these services, leading to operational disruptions.


7. Resolution Steps
Verify Mount Point: Checked if the mount point /mnt/ebs_volume existed and created it if necessary.
Update Configuration: Ensured that the /etc/fstab file had the correct entry for the EBS volume.
Manually Mount the Volume: Executed the mount command manually to ensure successful mounting.
Restart Services: Restarted the affected services to restore functionality.


8. Recommendations
Pre-check Configuration: Ensure that all mount points are created and properly configured before service startups.
Dependency Management: Implement service dependency management to ensure that services dependent on mounted filesystems start only after successful mounts.
Monitoring: Set up monitoring alerts for mounting failures to catch issues early.


9. Conclusion
The mounting issue was resolved by creating the necessary mount point and successfully mounting the EBS volume. All affected services were restarted and are now functioning normally. Further preventive measures will be implemented to avoid recurrence.

testing