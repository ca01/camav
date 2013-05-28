#!/usr/bin/python
#=======================================================================
#
#		   FILE: is_file_done_bash.py
#
# 		  USAGE: This file is used by the upanddown.sh script with
#				 the parameter $FILETOBESCAN
#				 E.g. python /usr/local/camav/is_file_done_bash.py 
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#				 This file is part of Camav processing engine.
#
#				 This file has to:
#				 - check if the result file is ready (result file is the
#				 xml file with details of the submited file and details
#				 of the detection);
#				 - if the file exist it parses it;
#				 - insert into the table sample, the details of the
#				 processed file;
#				 - insert into the table detection results of the
#				 scanning process;
#				 - updates the activetasks_av table, marking the scanned
#				 file as being processed (updates the field
#				 actaav_active with 0);
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
from xml.dom.minidom import parseString


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
		#config.read('camav_py.conf')
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
intConfFileRead=0
host,username,passwd,dbname,intConfFileRead=read_config_py_file()

#	END OF Configuration File	=======================================
#======================================================================



# For the future version, here should be implemented a kind of
# central error manager, where all the scripts making part of this
# system should report. That's beacuse as it is today, if a script
# fails the other scripts will not know and take for granted
# the results of the previous script are good.


# Comment: If the execution exit here,check if the config file is 
# accessible to the script, and if it is and still give errors, 
# check if the ConfigParser is included in the library.

if (intConfFileRead==0):# if the configuration file is not read ->exit
	print "The SCRIPT IS NOT WORKING"
	print "Configuration file could not be read, check if the conf file camav_py.conf is present"
	### here should come the log function
	#sys.exit("The SCRIPT IS NOT WORKING")

if len(sys.argv)<2:
    print "This script should be called followed by one parameter (nameoffile that has to be scanned)"
    sys.exit(1)

strFilename_argument=sys.argv[1]
strFilename = '/var/www/camav/processed/res_'+strFilename_argument
#print strFilename
if os.path.isfile(strFilename):
	print "host name %s " %host
	print "User name %s " %username
	print "Passwd is %s " %passwd
	print "database name is %s" %dbname
	time.sleep(5)
	conn = MySQLdb.connect (host,username,passwd,dbname)
	# prepare a cursor object using cursor() method
	cursor = conn.cursor()
	# Prepare SQL query

	now = datetime.datetime.now()
	actaav_procstarttime=now.strftime("%Y-%m-%d %H:%M:%S")

	#open the xml file for reading:
	file = open(strFilename,'r')
	#convert to string:
	data = file.read()
	#close file because we dont need it anymore:
	file.close()
	#parse the xml you got from the file
	dom = parseString(data)


	sam_md5 = dom.getElementsByTagName('sam_md5')[0].firstChild.data
	sam_sha1 = dom.getElementsByTagName('sam_sha1')[0].firstChild.data
	sam_sha256 = dom.getElementsByTagName('sam_sha256')[0].firstChild.data
	sam_filename = dom.getElementsByTagName('sam_filename')[0].firstChild.data
	sam_filesize = dom.getElementsByTagName('sam_filesize')[0].firstChild.data
	sam_firstSeen = dom.getElementsByTagName('sam_firstSeen')[0].firstChild.data
	sam_filetype_id = dom.getElementsByTagName('sam_filetype_id')[0].firstChild.data
	sam_ip = dom.getElementsByTagName('sam_ip')[0].firstChild.data
	intActiveTask_av_Id = dom.getElementsByTagName('acta_av_id')[0].firstChild.data
	#aici trebe avut grija cu parsarea datei si cu ce pun in bd
	strNewDate=dom.getElementsByTagName('sam_firstSeen')[0].firstChild.data
	query="INSERT INTO `"+dbname+"`.`samples` (`sam_id`, `sam_md5`, `sam_sha1`, `sam_sha256`, `sam_filename`, `sam_filesize`, `sam_firstSeen`, `sam_filetype_id`, `sam_path`, `sam_ip`) VALUES (NULL, \""+sam_md5+"\", \""+sam_sha1+"\", \""+sam_sha256+"\", \""+sam_filename+"\", \""+sam_filesize+"\", \""+strNewDate+"\", "+sam_filetype_id+", \"path\", \""+sam_ip+"\")";
	#print query

	try:
		print query
		# Execute the SQL command
		cursor.execute(query)
		# Commit your changes in the database
		conn.commit()
		#print "update ok"
		# get ID of last inserted record
		# if something goes wrong with the query this execution is not hiting this point
		# therefore this variable is uninitialized (therefore no insersion if the detection table)
		intSampleId=int(cursor.lastrowid)
		# print "ID of inserted record is ", intSampleId
	except Exception as e:
		print "except"
		# Rollback in case there is any error
		conn.rollback()
		print "Invalid update query: %s" %query
		print "the exception is: %s"

	avs = dom.getElementsByTagName("av")
	# print avs
	intLineNumber=0
	for av in avs:
		avname =av.getElementsByTagName("avname")[0].firstChild.data
		print "avnam : %s" %avname
		avversion =av.getElementsByTagName("avversion")[0].firstChild.data
		print "avversion : %s" %avversion
		avupdate =av.getElementsByTagName("avupdate")[0].firstChild.data
		print "avupdate : %s" %avupdate
		avdetection =av.getElementsByTagName("avdetection")[0].firstChild.data
		print "avdetection : %s" %avdetection
		intLineNumber=intLineNumber+1
		detection=""
		if (avdetection!="-"):
		    detection="positive"
		query="INSERT INTO `"+dbname+"`.`detection` (`det_id`, `det_sam_id`, `det_av_id`, `det_name`, `det_time`, `det_av_update`, `det_result`) VALUES (NULL, "+str(intSampleId)+", "+str(intLineNumber)+", \""+avdetection+"\", '2011-10-21 00:00:00', \""+strNewDate+"\", \""+detection+"\")"
		try:
			print query
			# Execute the SQL command
			cursor.execute(query)
			# Commit your changes in the database
			conn.commit()
		except Exception as e:
			# Rollback in case there is any error
			conn.rollback()
			print "Invalid update query: %s" %query
			print "the exception is: %s"

	# Here it is the part where I am updating the activetask_av table, with the end time of the task, and changing the status of the task from
	# active=1 to active=0

	now = datetime.datetime.now()
	date_actaav_endtime=now.strftime("%Y-%m-%d %H:%M:%S")
	query="UPDATE `"+dbname+"`.`activetasks_av` SET `actaav_endtime` = '"+date_actaav_endtime+"',`actaav_active` = '0' WHERE `activetasks_av`.`actaav_id` ="+intActiveTask_av_Id
	print query
	try:
		print query
		# Execute the SQL command
		cursor.execute(query)
		# Commit your changes in the database
		conn.commit()
		print "database updated successfuly";
		time.sleep(5)
		#os.remove("/var/www/camav/processed/res_"+$strFilename_argument)
		#$output=shell_exec("rm -r /var/www/camav/processed/res_".$strFilename_argument);
	except Exception as e:
		# Rollback in case there is any error
		conn.rollback()
		print "Invalid update query: %s" %query
		print "the exception is: %s"
else:
	print "The file does not exist" #The file does not yet exist...here it should be added that if something goes wrong 
	# and after a certain time the file is not yet there, to stop the function and show an error
	# echo "The file $filename does not exist";
