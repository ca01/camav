#!/usr/bin/python
#=======================================================================
#
#		   FILE: queue_get.py
#
# 		  USAGE: This is the camav daemon file;
#				 The entire application depends on this file
#				 E.g. python queue_get.py
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#
#				 The logic of the script is the followin:
#				 It queries the db table queue for task. It should list
#				 only one task at once (query limit 1). If there is
#				 something return, the script tries to update that query
#				 with the status locked (This operation is done using
#				 transaction). A variable intstatusTransaction is used
#				 to see if the transaction was succesfull or not. If the
#				 update was not successful there is no need to delete,
#				 but to update it back with the status unlocked.
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
		config.read('camav_py.conf')
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


try:
	conn = MySQLdb.connect (host,username,passwd,dbname)
	intConnected=1
except:
	print "Error connecting to MySql server"
	intConnected=0
print "CAMAV v1.0 daemon" 

if (intConfFileRead==1):# if the configuration file is not read ->exit
	print "Config file loaded.....................[Ok]"
	print "Waiting for files in the queue ........[Ok]"
	while True:
		intConnected=0
		# At this point something has to be done for the case
		# where mysql server dies. Maybe an external watchdog??
		
		if conn.open:
			#print "The Connection is open;"
			intConnected=1
		else:
			print "The Connection is NOT open; needs to be reinitialised;"
			try:
				conn = MySQLdb.connect (host,username,passwd,dbname)
				intConnected=1
			except:
				print "Error connecting to MySql server"
				intConnected=0


		if (intConnected==1):
			intStatusTransaction=0
			# prepare a cursor object using cursor() method
			cursor = conn.cursor()

			# Prepare SQL query to SELECT required records
			now = datetime.datetime.now()
			actaav_procstarttime=now.strftime("%Y-%m-%d %H:%M:%S")

			query="SELECT * FROM `queue` where que_locked =0 order by que_timequeue limit 1"
			#print "The SELECT query is : %s " % query
			try:
				# Execute the SQL command
				cursor.execute(query)
				# Commit your changes in the database
				conn.commit()
				#print "update ok"
			except:
				# Rollback in case there is any error
				conn.rollback()
				print "Invalid SELECT query: %s" %query

			# Fetch a single row using fetchone() method.
			#data = .fetchone()

			numrows = int(cursor.rowcount)
			if (numrows>0) :   # In case that I found something in the queue table
				for i in range(numrows):
					row = cursor.fetchone()
					#print row[0], row[1]
					que_id=row[0]
					#print "<br>"
					#print que_id,
					que_md5=row[1]
					#print que_md5
					que_sha1=row[2]
					#print que_sha1 
					que_filename=row[3]
					#print que_filename
					que_filesize=row[4]
					#print que_filesize
					que_timequeue=row[5]
					#print que_timequeue				
					que_timeout=row[6]
					#print que_timeout				
					que_priority=row[7]
					#print que_priority				
					que_uid=row[8]
					#print que_uid				
					que_ip=row[9]
					#print que_ip				
					que_task_type=row[10]
					#print que_task_type
					que_locked=row[11]
					#print que_locked
					print que_id, que_md5, que_sha1, que_filename, que_filesize, que_timequeue, que_timeout, que_priority, que_uid, que_ip, que_task_type, que_locked

				# After each transaction I'm closing the cursor, and before the new
				# transaction I'm reinitialising the connection. Otherwise, looks
				# that you get old result from the cach.
				cursor.close()
				cursor = conn.cursor()

				query="UPDATE `sandbox`.`queue` SET `que_locked`= '1' WHERE `queue`.`que_id`="+str(que_id)
				print "The UPDATE query is : %s " % query
				try:
					# Execute the SQL command
					cursor.execute(query)
					# Commit your changes in the database
					conn.commit()
					#print "update ok"
					intStatusTransaction=intStatusTransaction+1
				except:
					# Rollback in case there is any error
					conn.rollback()
					print "Invalid update query: %s" %query
				
				# After each transaction I'm closing the cursor, and before the new
				# transaction I'm reinitialising the connection. Otherwise, looks
				# that you get old result from the cach.
				cursor.close()
				cursor = conn.cursor()		

				if (intStatusTransaction==1):		
					# HERE come some processing 
					
					cmd = '/usr/local/camav/./upanddown.sh /var/www/camav/upload/'+que_filename
					print que_filename
					time.sleep(5)
					os.system(cmd)
					query="DELETE FROM `sandbox`.`queue` WHERE `queue`.`que_id` ="+str(que_id)
					print "The Delete query is : %s " % query	
					try:
						# Execute the SQL command
						cursor.execute(query)
						# Commit your changes in the database
						conn.commit()
						print "Delete ok"
						intStatusTransaction=intStatusTransaction+1
					except:
						# Rollback in case there is any error
						conn.rollback()
						print "Invalid Delete query: %s" %query
				else:#(intStatusTransaction==1)
					print "Something went wrong with the update transcation, therefore the record is not deleted"
					

				if (intStatusTransaction==2):
					print "The transactions went well"
				else:#(intStatusTransaction==1)
					print "Something went wrong with the update transcation, therefore the situation is restored as it was in the begining"
					query="UPDATE `sandbox`.`queue` SET `que_locked` = '0' WHERE `queue`.`que_id`="+str(que_id)
					print "The UPDATE query is : %s " % query
					try:
						# Execute the SQL command
						cursor.execute(query)
						# Commit your changes in the database
						conn.commit()
						#print "update ok"
						intStatusTransaction=intStatusTransaction+1
					except:
						# Rollback in case there is any error
						conn.rollback()
						print "Invalid update query: %s" %query
					
			#else: # if (numrows>0) : 
				#print "Nothing left in the queue"
			# disconnect from server
			cursor.close()
		else: # if (intConnected==1):
			print "Coulnt't connect to MySql Server; Try again in 3 sec"
		time.sleep(3)
else: #if (intConfFileRead==1)
	print "The DAEMON IS NOT WORKING"
	print "Configuration file could not be read, check if the conf file camav_py.conf is present"

