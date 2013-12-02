zarafaArchiverMultipleConfigs
=============================

Archive mails with Zarafa Archiver with different configurations for different users

How to use zarafaArchiverMultipleConfigs
----------------------------------------

The zarafaArchive.sh script must run on the Zarafa Archiver server

To be able to run this you will need:
 
* zarafa-archiver
* ldapsearch
* mail

1. Configure
------------

Change the following settings in archiver-wrapper.cfg

- SEARCHBASE (The searchbase of your LDAP/AD ex: dc=example,dc=com
- SEARCHSTRING (The attribute in LDAP/AD where ldapsearch can find the username)
- LOGS (The path where the logfiles can be written)
- RCPT (Emailadress to receive the logfiles)
- SENDER (FROM emailadress that sends the logfiles)

- FILTERGROUP[0] (The attribute that is specific for a users)
  It is possible to make more filtergroups, just change the 0

- CONFIG[0] (The path where the configuration can be found)
  CONFIG[0] will be linked to FILTERGROUP[0]

2. Run script
-------------

Run the script with:

cd /path/to/zarafaArchiverMultipleConfigs
./zarafaArchive.sh

3. Run it in cron
-----------------

If you want to archive mails periodically put the command to run the script in crontab:
 
```
# This will run @ 00:00, logging will go to /dev/null
0 7,12,0 * * * cd /path/to/zarafaArchiverMultipleConfigs && ./zarafaArchive.sh > /dev/null
```
