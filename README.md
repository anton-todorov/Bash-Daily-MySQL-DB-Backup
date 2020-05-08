# Bash Daily MySQL DB Backup
Shell script to backup mysql databases. 

### Prerequisites: 
```
Tested on OS X 10.11: El Capitan with MySQL v 5.6
```

### Installing
Suggested using a cron job

* Command to list all current cron jobs:
```
crontab -l
```

* Expected output if none current cron jobs found:
```
crontab: no crontab for user
```

* Command to edit the crontab:
```
crontab -e
```

* Example for a cron job to send out an email once a day at 00:00 AM:
```
0 0 * * * /usr/bin/php /var/www/html/crontest/cron.php >/dev/null 2>&1
```

* Explination for cron scheduling
```
 # * * * * *  command to execute
 # │ │ │ │ │
 # │ │ │ │ │
 # │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
 # │ │ │ └────────── month (1 - 12)
 # │ │ └─────────────── day of month (1 - 31)
 # │ └──────────────────── hour (0 - 23)
 # └───────────────────────── min (0 - 59)
 ```
 
 * External resources for scheduling jobs with crontab on Mac OS X 
 [Ole Michelsen] (https://ole.michelsen.dk/blog/schedule-jobs-with-crontab-on-mac-osx.html)
 
## Todo
- Archiving of the directories, older than "Today"
- E-mailing with daily log
 
 ## Authors

* **Anton Todorov** - *Initial work* - [LinkedIn](www.linkedin.com/in/anton-todorov89) | [GitHub](https://github.com/anton-todorov)

### Others
[Contributors](https://github.com/anton-todorov/Bash-Daily-MySQL-DB-Backup/graphs/contributors) who participated in this project.

## License

This project is free of license, thus LICENSE.md is not present.

## Credits and acknowledgments
Original by Leaman Crews, <leamanc@gmail.com>