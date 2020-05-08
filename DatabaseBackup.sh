#!/bin/bash

# Shell script to backup mysql databases. 
# Edited by Anton Todorov, <anton.todorov89@gmail.com>.
# Backs up all tables of all databases on a specified host to sql files (can be gzipped if needed). 
# Suggested for one backup per datestamp. If triggered ten times in one day, the script will create ten different backups for that day. 
# Version 2.0 (11/13/2014): Option for excluding databases from backup. 

# Suggested to be triggered as root, but not necessary. 

# Defining username, password and hostname
MyUSER="user"						# MySQL username
MyPASS="pass"						# MySQL password. Use if the user does have password, else leave as ""
MyHOST="127.0.0.1"					# MySQL host IP address

# Paths to binaries - hardcoded as they can't be autodetected via the 'which' command in our situation.
MYSQL="/usr/local/mysql/bin/mysql"
MYSQLDUMP="/usr/local/mysql/bin/mysqldump"
#CHOWN="$(which chown)"				# Checking CHOWN for future development purposes
#CHMOD="$(which chmod)"				# Checking CHMOD for future development purposes
GZIP="$(which gzip)"

#currentUser=$(ls -l /dev/console | awk '{ print $3 }') # Gets the current username

# Path to the Main directory where all backups will be stored.
DEST="Volumes/Mac OS X/Users/Administrator/Desktop/backupDir"
cd "/$DEST"							# Change the current directory to the destination directory where all backups will be stored.

#WEEK="$(date +"%V")"				# Variable for week number. %W(Monday start, 00-53), %U(Sunday start, 00-53), %V(ISO, Monday start, 01-53)
WEEK="$(($(date +"%W")+1))"			# Variable for week number. %W(Monday start, 00-53), %U(Sunday start, 00-53), %V(ISO, Monday start, 01-53)

# Name of the Main Backup Directory where all backup will be stored.
MBD="Week #$WEEK"

# Check if the main backup directory exists and create it if not.
[ ! -d "$MBD" ] && mkdir -p "$MBD" || :

	# Check if an old directory (older than 3 weeks) exist and delete if so.
	OLDDIR="$(($WEEK-2))"			# Variable for 'Week-2' number.
	OLDMBD="Week #$OLDDIR"			# Name of the old directory which will be deleted.
	[ -d "$OLDMBD" ] && rm -rf "$OLDMBD" || :	# Check if old directory exists and delete it.
	
		# Explicit check for last directories from previous year as the above week counter is restored with the new year trigger.
		# Check if 'Week #3' directories exists and delete the last few directories from the last year.
		[ -d "Week #3" ] && rm -rf "Week #50" && rm -rf "Week #51" && rm -rf "Week #52" && rm -rf "Week #53" || :
	
cd "/$DEST/$MBD"					# Change the current directory to the Main directory for backups.

# Check if a directory with a name of the host exists and create it if not.
[ ! -d "$MyHOST" ] && mkdir -p "$MyHOST" || :

# Set ownership to current user for current host backup folder.
# NOTE: This rights will be given to the user of the operating system that executes the code, not to the MySQL User!
#CHOWN 503 "/$DEST/$MBD"			# Setting the owner. (use only if needed)
#CHMOD 0777 "/$DEST/$MBD/$MyHOST"	# Setting user rights for the current user to access the destination folder.

cd "/$DEST/$MBD/$MyHOST"			# Change the current directory to the directory with the host name.

# Immediate directory of the backup itself.
NOW="$(date +%d-%m-%Y_%Hh%Mm%Ss)"		# Variable for today's timestamp. 
[ ! -d "$NOW" ] && mkdir -p "$NOW" || :	# Check if exists and create it if not.
cd "$NOW"								# Change the current directory to the directory with the current time name.
LOGFILENAME="[error_log]$NOW.txt"		# Defining logfile name.

# Looping the databases in the defined host. Excluding databases definition.
for db in `$MYSQL -u $MyUSER -h $MyHOST -p$MyPASS -Bse 'show databases' | grep -Ev '(Database|information_schema|performance_schema|mysql)'`; 
do

echo "== = --- = == Now running in database $db == = --- = =="
	
	# Looping the tables in the databases of the host. Excluding tables definition.
	for tb in `$MYSQL -u $MyUSER -h $MyHOST -p$MyPASS $db -e 'show tables' | grep -v '^Tables_in_'`; # Use if the user does have password.
	do

	echo "--== Now Dumping Table $tb ==--"
	
	OUTPUTFILENAME="$db-$tb".sql		# Output filename variable  - Used to store the backup file.

	# Actual data extraction with log file. 
	$MYSQLDUMP --single-transaction --force --quick --compact --lock-tables=false --log-error=$LOGFILENAME -u $MyUSER -h $MyHOST -p$MyPASS $db $tb > $OUTPUTFILENAME
	
	#$GZIP -c $OUTPUTFILENAME > $OUTPUTFILENAME.gz && rm $OUTPUTFILENAME # Use if needed to GZIP every table. Removes the OUTPUTFILENAME.sql file after archiving. 
	
	#[ ! -s $LOGFILENAME ] && rm $LOGFILENAME || :			#If log.txt is empty delete it
	#[ -f "$LOGFILENAME" ] && less -FX $LOGFILENAME || :	# If a log.txt file exist, display the content of the log.txt file. 
	
	done

done
exit

# Additional troubleshoot or further developing commands
#mysql> select concat('KILL ',id,';') from information_schema.processlist where user='root' and time > 200 into outfile '/tmp/a.txt';
#mysql> source /tmp/a.txt;
#--END

#$GZIP -r DIR
#sudo /usr/local/mysql/support-files/mysql.server restart	# Restart of the MySQL

#sleep 5 # Delay of 5 seconds

######################  Credits ########################
### Original by Leaman Crews, <leamanc@gmail.com>    ###
########################################################
