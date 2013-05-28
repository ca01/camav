#!/usr/bin/python
#=======================================================================
#
#		   FILE: task_process_update.py
#
# 		  USAGE: This file is used by the upanddown.sh script with
#				 the parameter $md5 $activetaskid
#				 E.g.python task_process_update.py $md5 $activetaskid				 
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#
#				 The file has to update the activetasks_av table, once
#				 the processing of the file is finished.
#
# 		OPTIONS: ---
#  REQUIREMENTS: ---
# 		   BUGS: ---
#		  NOTES: ---
# 		 AUTHOR: ca01
# 		VERSION: 1.0
# 		CREATED: 11.09.2012
# 	   REVISION: ---
#		   TODO: * clean up
#	 CHANGE LOG: ---
#=======================================================================

import os
import sys
import time
import MySQLdb
import datetime
import ConfigParser




#======================================================================
#	FUNCTIONS	=======================================================

#=== FUNCTION "read_config_py_file" ===================================
#			NAME: read_config_py_file
#	 DESCRIPTION: Read the configuration python file, and return 
#				  the values from the config file. The default 
#				  config file is camav_py.conf
#				  The variable intConfFileRead is used to indicate if
#				  the file was read or not. If it was not read the
#				  program should exit .
#	  PARAMETERS: -
#		   USAGE: host,username,passwd,dbname,intConfFileRead=read_config_py_file()
#======================================================================

def read_config_py_file():
	try:
		config = ConfigParser.RawConfigParser()
		config.read('/usr/local/camav/camav_py.conf')
		host=config.get('Section1', 'host')
		username = config.get('Section1', 'username')
		passwd = config.get('Section1', 'passwd')
		dbname = config.get('Section1', 'dbname')
		intConfFileRead=1
	except:
		host=""
		username = ""
		passwd = ""
		dbname = ""
		intConfFileRead=0
	return host,username,passwd,dbname,intConfFileRead
#===	END OF FUNCTION "read_config_py_file" =========================


#	END Of Functions 	===============================================
#======================================================================



#======================================================================
#	LOCAL VARIABLES	===================================================

intStatusTransaction=0
intConnected=0
#	END OF LOCAL VARIABLES	===========================================
#======================================================================




#======================================================================
#	Configuration File	===============================================

#----------------------------------------------------------------------
#	Reading the configuration file. Maybe more checks need to be added 
#	to verify if the parameters are good
#----------------------------------------------------------------------
host,username,passwd,dbname,intConfFileRead=read_config_py_file()

#	END OF Configuration File	=======================================
#======================================================================



# Comment: If the execution exit here,check if the config file is 
# accessible to the script, and if it is and still give errors, 
# check if the ConfigParser is included in the library.
if (intConfFileRead==0):# if the configuration file is not read ->exit
	print "The SCRIPT IS NOT WORKING"
	print "Configuration file could not be read, check if the conf file camav_py.conf is present"
	### here should come the log function
	#sys.exit("The SCRIPT IS NOT WORKING")

if len(sys.argv)<3:
    print "This script should be called followed by two parameters (md5 and activetaskid)"
    sys.exit(1)

strMD5=sys.argv[1];
intActivetaskId=sys.argv[2]


conn = MySQLdb.connect (host,username,passwd,dbname)
# prepare a cursor object using cursor() method
cursor = conn.cursor()


# Prepare SQL query to UPDATE required records

now = datetime.datetime.now()
actaav_procstarttime=now.strftime("%Y-%m-%d %H:%M:%S")

query="UPDATE `"+dbname+"`.`activetasks_av` SET `actaav_procstarttime` = '"+actaav_procstarttime+"' WHERE `activetasks_av`.`actaav_id` ="+intActivetaskId+" AND `activetasks_av`.`actaav_md5`='"+strMD5+"'"
print "The query is : %s " % query
try:
	print "host name %s " %host
	print "User name %s " %username
	print "Passwd is %s " %passwd
	print "database name is %s" %dbname
	time.sleep(5)
	# Execute the SQL command
	cursor.execute(query)
	# Commit changes in the database
	conn.commit()
	#print "update ok"
except:
	# Rollback in case there is any error
	conn.rollback()
	print "Invalid update query: %s" %query


# disconnect from server
cursor.close()
conn.close()
