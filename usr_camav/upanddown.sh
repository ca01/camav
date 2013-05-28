#!/bin/bash
#=======================================================================
#
#		   FILE: upanddown.sh
#
# 		  USAGE: This file is used by the daemon file queue_get.py with
#				 a parameter which is the name of the file to be scanned
#				 E.g. upanddown.sh /var/www/camav/upload/'+que_filename 
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#				 This file is part of Camav processing engine.
# 
#				 Manages Virtual Machines with Antiviruses for VBox
#				 guest machine.
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


########################### WARNING ###################################
#######################################################################
#######################################################################
# THIS SCRIPT WORKS ONLY WITH VERSIONS OF VIRTUAL BOX GREATER THAN
# 4.1.6r74713
# The versions of virtual box greated that4.1.6r74713, have changed some
# commands parameters and the order of the parameters therefore the
# command
#
# $VBOXMANAGE guestcontrol exec ${MACHINENAMES[$i]} $SCRIPTNAME bla
#
# will generate an error.
#
# The versions greated that4.1.6r74713 have the command line something
# like
#
# $VBOXMANAGE guestcontrol ${MACHINENAMES[$i]} exec $SCRIPTNAME bla bla
#
#######################################################################
#######################################################################


#======================================================================
#	LOCAL VARIABLES	===================================================

CONFIG_FILE="camav.conf"
BOOL_EXIT=
NAME_OF_THE_SCRIPT="`basename $0`"
#	END OF LOCAL VARIABLES	===========================================
#======================================================================

#======================================================================
#	Configuration File	===============================================

#----------------------------------------------------------------------
#	Reading the configuration file. Maybe more checks need to be added 
#	to verify if the parameters are good
#----------------------------------------------------------------------
if [[ -f $CONFIG_FILE ]]; then
        . $CONFIG_FILE
fi
#	END OF Configuration File	=======================================
#======================================================================

WITH_OR_WITHOUT_HEAD=""
if [[ $HEAD -eq 0 ]]
	then WITH_OR_WITHOUT_HEAD=" --type headless"
fi
#echo $WITH_OR_WITHOUT_HEAD


# HERE THERE SHOULD BE A CHECK  (in the future version) the check if
# the config file is loaded and if the variables from the config files
# are corect and not empty.
# To avoid hardlinks the configuration file should be in the same place
# as the script that loads it.


#======================================================================
#	FUNCTIONS	=======================================================

#=== FUNCTION "log"====================================================
#			NAME: log
#	 DESCRIPTION: Write the text in the log file.
#				  The log has the following format
#				  date | time | time zone | name of the program that
#				  generates the log | log line 
#				  E.g. 11-09-2012 14:39:42 +01:00 [upanddown.sh]
#				  Shutdown the machine
#	  PARAMETERS: Text to be log
#======================================================================

log()
	{
	    message=`date +"%d-%m-%Y %T  %:z"`
	    message=$message" ["$NAME_OF_THE_SCRIPT"]"" $@"
	    echo  $message
	    echo $message >>$LOGFILE
	}
#===	END OF FUNCTION "log"	=======================================


#=== FUNCTION "version"	===============================================
#			NAME: version
#	 DESCRIPTION: Prints the script version. 
#	 PARAMETER 1: ---
#		   USAGE: version
#======================================================================

version()
	{
	    echo "    "
	    echo "CAMAV - Multi Antivirus Engine"
	    echo "Manages Virtual Machines with Antiviruses for VirtualBox guest machine."
	    echo "    "
	    echo "This script is used for manipulating the virtual machines. It stats the"
	    echo "machines, scans the file with each antivirus and stops the machines."
		echo "    "
	    echo "Version: "$NAME_OF_THE_SCRIPT" Version 1.0 Build 11.09.2012"
		echo $NAME_OF_THE_SCRIPT" Version 1.0 Build 11.09.2012" >>$LOGFILE
	}
#===	END OF FUNCTION "version"	===================================


#=== FUNCTION "usage"	===============================================
#			NAME: usage
#	 DESCRIPTION: Prints the usage of the script with all possible
#				  parameters
#	 PARAMETER 1: ---
#		   USAGE: usage
#======================================================================

usage()
	{
	    echo "  Usage: "$NAME_OF_THE_SCRIPT" [options]"
	    echo "Options: "
	    echo "          [-v] - prints out the version of the script."
	    echo "       "
	    echo "          [-m] <name of the machine> "
	    echo "              - updates a particular machines or a list of machines separated by space."
	    echo "                if no parameter is specified or -m without any machines, all machines "
	    echo "                defined in camav.conf are updated."
	    echo "       "
	    echo "          [-h] - prints out this help."
	    echo $NAME_OF_THE_SCRIPT" Usage" >>$LOGFILE
	}
#===	END OF FUNCTION "usage"	=======================================


#=== FUNCTION "processing_avso"	=======================================
#			NAME: processing_avso
#	 DESCRIPTION: Sophos Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avso
#======================================================================

processing_avso()
	{
		strProductName="Sophos"
		strVersionName=`awk '/Virus data version/ {print $4}' avso.txt| tr -d ',\r'`
		strUpdateDate=`date +%d.%m.%y` 
		#CURRENT DATA, if av was not updated could misslead #######to be revised
		#strUpdateDate=`awk '/System date/ {print $6,$7,$8}' avso.txt | tr -d ',\r'` 
		strInfection=`awk -F \' '/>>>/ {print $2}' avso.txt | tr -d '\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avso"	===========================



#=== FUNCTION "processing_avmc"	=======================================
#			NAME: processing_avmc
#	 DESCRIPTION: McAfee Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avmc
#======================================================================

processing_avmc()
	{
		strProductName="McAfee"
		strVersionName=`awk '/AV     DAT Version/ {print $5}' avmc.txt| tr -d '\r'`
		strUpdateDate=`awk '/AV     DAT Version/ {print $11,$10,$12}' avmc.txt | tr -d ',\r'` 
		strUpdateDate=`date -d "$strUpdateDate" +%d.%m.%y`
		strInfection=`awk -F \" '/called/ {print $4}' avmc.txt | tr -d '\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avmc"	===========================




#=== FUNCTION "processing_avmcc"	===================================
#			NAME: processing_avmcc
#	 DESCRIPTION: McAfee Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avmcc
#======================================================================

processing_avmcc()
	{
		strProductName="McAfeeEC"
		strVersionName=`awk '/AV     DAT Version/ {print $5}' avmcc.txt| tr -d '\r'`
		strUpdateDate=`awk '/AV     DAT Version/ {print $11,$10,$12}' avmcc.txt | tr -d ',\r'` 
		strUpdateDate=`date -d "$strUpdateDate" +%d.%m.%y`
		strInfection=`awk -F \" '/called/ {print $4}' avmcc.txt | tr -d '\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avmcc"	===========================



#=== FUNCTION "processing_avfs"	=======================================
#			NAME: processing_avfs
#	 DESCRIPTION: F-Secure Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avfs
#======================================================================

processing_avfs()
	{
		strProductName="F-Secure"
		strVersionName=`awk '/F-Secure Anti-Virus Command Line Scanner/ {print $7}' AVFS.TXT| tr -d '\r'`
		strUpdateDate=`awk '/F-Secure Aquarius:/ {print $4}' AVFS.TXT | tr -d '\r'` 
		## Here I probably have to read both dates and process the latest
		# Needs to be revised

		strUpdateDate=`echo $strUpdateDate | awk -v R="" '{ gsub(/./,"&\n") ; print $9$10"."$6$7"."$3$4}'`
		strInfection=`awk '/Infection:/ {print $3}' AVFS.TXT | tr -d '\r'`
		if [ "$strInfection" = "" ] 
			then
			 strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avfs"	===========================



#=== FUNCTION "processing_avcl"	=======================================
#			NAME: processing_avcl
#	 DESCRIPTION: ClamWin Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avcl
#======================================================================

processing_avcl()
	{
		strProductName="ClamWin"
		strVersionName=`awk '/Engine version:/ {print $3}' avcl.txt| tr -d ',\r'`
		strUpdateDate=`date +%d.%m.%y` #CURRENT DATA, if av was not updated could misslead #######to be revised
		#strUpdateDate=`awk '/Known viruses:/ {print $3}' avcl.txt | tr -d '\r'` 
		strInfection=`awk  '/FOUND/ {print $2}' avcl.txt | tr -d '\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avcl"	===========================



#=== FUNCTION "processing_avav"	=======================================
#			NAME: processing_avav
#	 DESCRIPTION: Avira Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avav
#======================================================================

processing_avav()
	{
		strProductName="Avira"
		strVersionName=`awk '/engine set:/ {print $3}' avav.txt| tr -d ',\r'`
		strUpdateDate=`date +%d.%m.%y` #CURRENT DATA, if av was not updated could misslead #######to be revised
		#strUpdateDate=`awk '/VDF Version:/ {print $3}' avav.txt | tr -d '\r'` 
		strInfection=`awk  '/ALERT:/ {print $2}' avav.txt | tr -d '[]\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avav"	===========================


#=== FUNCTION "processing_avvb"	=======================================
#			NAME: processing_avvb
#	 DESCRIPTION: VirusBuster Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avvb
#======================================================================

processing_avvb()
	{
		strProductName="VirusBuster"
		strVersionName=`awk '/is started/ {print $2}' avvb.txt| tr -d ',\r'`
		strUpdateDate=`awk '/vdb / {print $3}' avvb.txt | tr -d '()\r'` 
		strUpdateDate=`echo $strUpdateDate | awk -v R="" '{ gsub(/./,"&\n") ; print $9$10"."$6$7"."$3$4}'`

		strInfection=`awk  '/found:/ {print $3}' avvb.txt | tr -d '[]\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avvb"	===========================


#=== FUNCTION "processing_avavg"	===================================
#			NAME: processing_avavg
#	 DESCRIPTION: AVG Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avavg
#======================================================================

processing_avavg()
	{
		strProductName="AVG"
		strVersionName=`awk '/Program version/ {print $3}' avavg.txt| tr -d ',\r'`
		strUpdateDate=`awk '/Virus Database:/ {print $5}' avavg.txt | tr -d '\r'`
		strUpdateDate=`echo $strUpdateDate | awk -v R="" '{ gsub(/./,"&\n") ; print $9$10"."$6$7"."$3$4}'`
		strInfection=`awk  '/Virus identified|Trojan horse/ {print $4}' avavg.txt | tr -d '[]\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avavg"	===========================


#=== FUNCTION "processing_avka"	=======================================
#			NAME: processing_avka
#	 DESCRIPTION: Karspersky Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avka
#======================================================================

processing_avka()
	{
		strProductName="Karspersky"
		#The product does not show the version number and database number therefore is staticaly attribuited/
		#strVersionName=`awk '/is started/ {print $2}' avka.txt| tr -d ',\r'`
		#strUpdateDate=`awk '/vdb / {print $2}' avka.txt | tr -d '\r'` 
		strVersionName="6.0"
		strUpdateDate=`date +%d.%m.%y` #CURRENT DATA, if av was not updated could misslead #######to be revised
		strInfection=`awk  '/detected/ {print $5}' avka.txt | tr -d '[]\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avka"	===========================



#=== FUNCTION "processing_avno"	=======================================
#			NAME: processing_avno
#	 DESCRIPTION: NOD32 Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avno
#======================================================================

processing_avno()
	{
		strProductName="NOD32"
		strVersionName=`awk '/ECLS Command-line scanner/ {print $5}' avno.txt| tr -d ',\r'`
		strUpdateDate=`awk '/Module scanner/ {print $5}' avno.txt | tr -d ',()\r'` 
		strUpdateDate=`echo $strUpdateDate | awk -v O="" '{ gsub(/./,"&\n") ; print $7$8"."$5$6"."$3$4}'`
		strInfection=`awk -F\" '/threat/ {print $4}' avno.txt`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avno"	===========================



#=== FUNCTION "processing_avava"	===================================
#			NAME: processing_avava
#	 DESCRIPTION: AVAST Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avava
#======================================================================

processing_avava()
	{
		strProductName="AVAST"
		strVersionName="4.8"
		#strVersionName=`awk '/ECLS Command-line scanner/ {print $3}' avava.txt| tr -d ',\r'`
		strUpdateDate=`awk '/VPS:/ {print $4}' avava.txt | tr -d '\r'`
		strUpdateDate=`echo $strUpdateDate | sed -r 's#([0-9]{2})/([0-9]{2})/([0-9]{2})#\2.\1.\3#'`
		strInfection=`awk -F\] '/[L]/ {print $2}' avava.txt | tr -d '!(0)\r'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avava"	===========================



#=== FUNCTION "processing_avms"	=======================================
#			NAME: processing_avms
#	 DESCRIPTION: MS_ForeFront Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avms
#======================================================================

processing_avms()
	{
		strProductName="MS ForeFront"
		strVersionName=" 2.0.657"
		strUpdateDate=`date +%d.%m.%y` #CURRENT DATA, if av was not updated could misslead #######to be revised
		strInfection=`awk '/found no/ {print $4$3}' avms.txt`
		if [ "$strInfection" = "nofound" ]
		 then
		  strInfection="-"
		else
		  strInfection="Positiv"
		fi

		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avms"	===========================


#=== FUNCTION "processing_avtm"	=======================================
#			NAME: processing_avtm
#	 DESCRIPTION: TRENDMICRO Result Collecting 
#	 PARAMETER 1: ---
#		   USAGE: processing_avtm
#======================================================================

processing_avtm()
	{
		strProductName="TRENDMICRO"
		strVersionName="9.5"
		strUpdateDate=`awk '/pattern/ {print $8}' avtm.txt | tr -d '()'`
		strUpdateDate=`echo $strUpdateDate | cut -c3- | sed -r 's#([0-9]{2})/([0-9]{2})/([0-9]{2})#\3.\2.\1#'`
		strInfection=`awk -F" " '/>Found / {print $5}' avtm.txt | tr -d '[]'`
		if [ "$strInfection" = "" ]
		 then
		  strInfection="-"
		fi
		echo "<av name=\""${strProductName}"\">">>$resultfile
		echo "	<avname>"${strProductName}"</avname>">>$resultfile
		echo "	<avversion>"${strVersionName}"</avversion>">>$resultfile
		echo "	<avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
		echo "	<avdetection>"${strInfection}"</avdetection>">>$resultfile
		echo "</av>">>$resultfile
	}
#===	END OF FUNCTION "processing_avtm"	===========================



#=== FUNCTION "processing_avbd" =======================================
#        NAME: processing_abdv
#        DESCRIPTION: BITDEFENDER Result Collecting 
#        PARAMETER 1: ---
#                  USAGE: processing_avbd
#======================================================================

processing_avbd()
        {
                strProductName="BITDEFENDER"
                strVersionName="3.5.1.0"
                strUpdateDate=`awk '/pattern/ {print $8}' avbd.txt | tr -d '()'`
                strUpdateDate=`date +%d.%m.%y`
                strInfection=`awk -F" " '/>Found / {print $5}' avbd.txt | tr -d '[]'`
                if [ "$strInfection" = "" ]
                 then
                  strInfection="-"
                fi
                echo "<av name=\""${strProductName}"\">">>$resultfile
                echo "  <avname>"${strProductName}"</avname>">>$resultfile
                echo "  <avversion>"${strVersionName}"</avversion>">>$resultfile
                echo "  <avupdate>"${strUpdateDate}"</avupdate>">>$resultfile
                echo "  <avdetection>"${strInfection}"</avdetection>">>$resultfile
                echo "</av>">>$resultfile
        }
#===    END OF FUNCTION "processing_avbd"       =======================






#=== FUNCTION "param_valid"============================================
#			NAME: param_valid
#	 DESCRIPTION: Write the text in the log file.
#				  The log has the following format date | time | time zone | name of the program
#				  that generates the log | log line 
#				  E.g. 06-12-2011 14:39:42 +01:00 [desters.sh] Shutdown the machine
#	  PARAMETERS: Text to be log
#======================================================================

param_valid()
	{
	    #message=`date +"%d-%m-%Y %T  %:z"`
	    #message=$message" ["$NAME_OF_THE_SCRIPT"]"" $@"
	    #echo  $message
	    #echo $message >>$LOGFILE

		########### PARAMETER VALIDATION ##############################
		### CHECK IF THE PARAMETER EXIST ####
		if [ "$1" = "" ]
		then
		  echo " upanddown Usage: $0 <filename>"
		  echo " upanddown: missing operand"
		  exit
		fi
		###########################################################
		#### CHECK IF THE PARAMETER IS AN EXISTING FILE ON THE SYSTEM #
		if [ ! -e "$1" ]
		then
		  echo " upanddown Usage: $0 <filename>"
		  echo " upanddown: operand $1 does not exist on the system. It should be a valid file"
		  exit
		fi
		###############################################################
		#### CHECK IF THE PARAMETER IS A VALID FILE NOT A FOLDER ######
		if [ ! -f "$1" ]
		then
		  echo " upanddown Usage: $0 <filename>"
		  echo " upanddown: operand $1 is not a valid file. It's probably a folder It should be a valid existent file"
		  exit
		fi
		###############################################################
		############# END OF PARAMETER VALIDATION #####################
	}
#===	END OF FUNCTION "param_valid	===============================


#=== FUNCTION "processing_main"========================================
#			NAME: processing_main
#	 DESCRIPTION: This function restores the machine to the clean state,
#				  and run the script inside the Virtual machine.
#				  The function count the number of machines, and for
#				  each machine tries to:
#				  poweoff, restores the clean state, starts the machins,
#				  runs the avscript.
#	  PARAMETERS: -
#		   USAGE: processing_main
#======================================================================

processing_main()
{
		#Here starts the Machine UP AND DOWN PROCEDURE
		NumberOfMachines=${#MACHINENAMES[@]}
		echo $NumberOfMachines
		let startcount=0
		stopcount=$NumberOfMachines
		
		for (( i = $startcount ; i < $stopcount; i++ ))
			do
				log "# Turn the machine off brutaly"
				
				log "$VBOXMANAGE controlvm ${MACHINENAMES[$i]} poweroff"
				$VBOXMANAGE controlvm ${MACHINENAMES[$i]} poweroff

				# Restore the clean Image
				log "# Restore the clean Image"
				log "$VBOXMANAGE snapshot ${MACHINENAMES[$i]} restore clean1"
				$VBOXMANAGE snapshot ${MACHINENAMES[$i]} restore clean1

				# Startup the machine
				log "# Startup the machine."
				log "$VBOXMANAGE startvm ${MACHINENAMES[$i]} $WITH_OR_WITHOUT_HEAD"
				$VBOXMANAGE startvm ${MACHINENAMES[$i]} $WITH_OR_WITHOUT_HEAD

				# Run the bat file on each machine
				# Run bat file with parameters, bat file that scans the file and save everything in a file 

				BATFILEARGUMENT="Z:\\"$FOLDERNAME"\\"$FILETOBESCAN
				echo "BATFILEARGUMENT = " $BATFILEARGUMENT
				SCRIPTNAME="c:\\script\\"${MACHINENAMES[$i]}".bat"
				echo "SCRIPTNAME = "$SCRIPTNAME

				#THis command line is perimated. VBOX 4.2 modified the command line structure.
				#log "$VBOXMANAGE guestcontrol ${MACHINENAMES[$i]} exec $SCRIPTNAME --username test --password 123456 \"$BATFILEARGUMENT\""
				#$VBOXMANAGE guestcontrol ${MACHINENAMES[$i]} exec $SCRIPTNAME --username test --password 123456 "$BATFILEARGUMENT"
				
				# The version of the command line working with 4.2. and later.
				log "$VBOXMANAGE guestcontrol ${MACHINENAMES[$i]} exec --image $SCRIPTNAME --username test --password 123456 --verbose --wait-stderr --  \"$BATFILEARGUMENT\""
				$VBOXMANAGE guestcontrol ${MACHINENAMES[$i]} exec --image $SCRIPTNAME --username test --password 123456 --verbose --wait-stdout -- "$BATFILEARGUMENT"
				
			done
}
#===	END OF FUNCTION "processing_main"	===========================




#=== FUNCTION "processing_shutdown_machine"============================
#			NAME: processing_shutdown_machine
#	 DESCRIPTION: The function is shuting down all the macines. It
#				  waits for some seconds and then shut them down.
#				  The number of seconds should be in relation with the
#				  size of the file. This variable waiting time should
#				  be probably impemented in a later version of the
#				  program. For the moment the wait is 1 minute
#	  PARAMETERS: -
#		   USAGE: processing_main
#======================================================================
processing_shutdown_machine()
{
		NumberOfMachines=${#MACHINENAMES[@]}
		let startcount=0
		stopcount=$NumberOfMachines
		#sleep 180
		for (( i = $startcount ; i < $NumberOfMachines; i++ ))
		do
			log "# I turn them off brutaly"
			log "$VBOXMANAGE controlvm ${MACHINENAMES[$i]} poweroff"
			$VBOXMANAGE controlvm ${MACHINENAMES[$i]} poweroff
		done
}
#===	END OF FUNCTION "processing_shutdown_machine"	===============

#=== FUNCTION "processing_file_manipulation"===========================
#			NAME: processing_file_manipulation
#	 DESCRIPTION: This is the file manipulation function.
#				  The explanation: Each scan is generating a text
#				  file having the name av+<short name of the av>.txt
#				  (E.g. for Mcafee the file is avmc.txt) containing
#				  the results of the scanning of that product.
#				  The system is iterating through each generated file
#				  and parses it to check if a virus was detected. Each
#				  antivirus result file is processed by a function.
#				  Therefore, to add a new antivirus, a new parsing
#				  function needs to be added to the code.
#				  ATTENTION! For each result file I am searching for a
#				  pattern and print the column associated with the
#				  field. Once the file structure is changed by the AV
#				  provider, the script has to be updated.
#				  ATTENTION! Not all the AV providers write in the
#				  result file the date of the last update. Therefore,
#				  for an accurate “last update” field, a solution is
#				  needed. Maybe to keep the last update in a file, that
#				  is going to update each night. This needs to be fixed.
#	  PARAMETERS: -
#		   USAGE: processing_file_manipulation
#======================================================================

processing_file_manipulation()
{
	# Explanations
	# The xml result file looks like <file info> <md5>blabla</md5> </file info>.
	# In this part of the script I delete the tag </file info> and I am going to add it
	# at the end when all the detection infos are filled in. Without this artifice the
	# XML parser does not recognise the file as being valid xml file.  The real
	# delete is done by erasing the last line of the file. The “sed” part is filtering
	# also the blank line, to avoid that the sed delets only the last empty line and
	# not the line containing the tag </file info> . The sed deletes the last non
	# blank line.

	sed 's/  *$//;/^$/d' $resultfile | sed '$d' >$resultfile".tmp"
	mv $resultfile $resultfile".old"
	mv $resultfile".tmp" $resultfile
	rm -r -f $resultfile".old"
	echo "<detectioninfo>">>$resultfile

	# Explanations
	# For each antivirus there is an entry in the configuration file, variable array MACHINENAMES.
	# (E.g. avfs – F-Secure). The system allows to run with a variable number of antivirus-es defined in the
	# configuration file. For each antivirus that produces a scanning output (each output is different), there
	# is a function that parses the results and writes it to the result file.
	# Therefore if the system has 12 av, and we want to run only with 3, than the configuration file needs to be
	# adjust to have only these 3 entries in the MACHINENAMES variable. To avoid calling all the 12 functions that
	# parses all av input when we need only 3, we call them dynamically. Therefore, in this “for statement” I
	# compose the name of the function to be called based on the variable machine, read from the config file, and
	# therefore I call only the needed functions.

	functiontocall="null"
	NumberOfMachines=${#MACHINENAMES[@]}
	let startcount=0
	stopcount=$NumberOfMachines
	for (( i = $startcount ; i < $NumberOfMachines; i++ ))
	do
		function_to_call="processing_"${MACHINENAMES[$i]}
		echo "function to call is "$function_to_call
		$function_to_call
	done
	echo "</detectioninfo>">>$resultfile
	echo "</fileinfo>">>$resultfile

	##!!!!!!!!!!!!!!!!! TO BE REVISED  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	# THE RESULT FILE IS COPIED IN A PLACE WHERE APACHE HAS ACCESS TO IT
	# IT SHOULD BE REVIESED. THIS IS A TEMPORARY SOLUTIN 
	# THE FILE IS COPIED TO /var/www/camav/processed. FROM THIS LOCATION
	# APACHE HAS ACCESS TO IT TO READ IT AND SHOW IT.
	cp --preserve -v $resultfile "/var/www/camav/processed/"
	sleep 10

	cp --preserve -v $resultfile $INPUTFOLDER$FOLDERNAME
	
	python /usr/local/camav/is_file_done_bash.py $FILETOBESCAN
	
	rm -r -f $resultfile
	rm -r -f "/var/www/camav/processed/res_"$FILETOBESCAN
}
#===	END OF FUNCTION "processing_file_manipulation"	===============


#	END Of Functions 	===============================================
#======================================================================


#======================================================================
#=====	SCRIPT MAIN	===================================================

#----------------------------------------------------------------------
# 	V1.2 Comment
#	This is the MAIN part of the script where parameter are processed.
#----------------------------------------------------------------------

# WARNING The $1 parameter is the command line parameter used to run
# the script e.g "upanddown.sh file". The file could be specified
# both as a path the file and as only the name.
# For the case when is specified as path, the basename(file) is used.

FILETOBESCAN=`basename $1` 
FOLDERNAME=$FILETOBESCAN
echo "FILETOBESCAN = "$FILETOBESCAN


#1 cumva sa am access la fisierul care trebuie scanat (sa-l pun intr-un director, cel mai probabil salvat de upload-ul php) de unde sa-l copiez in directorul sharuit (/%#home/usename/inputscr/md5ofthefile+identificatorunic)
#2 pornesc masinile, intr-un status "clean"
#3 rulez pe fiecare masina un bat cu un parametru care este fisierulcare trebui scanat
#4 rezultatul antivirusului il salvez in /home/usename/inpuscr/md5ofthefile+identificatorunic/md5+av.txt
#5 fac un script care parseaza fisierele rezultat, si il da inapoi la server php
# ATENTIE DRIVE-ul MAPAT PE CLIENT TREBUIE SA FIE NEAPARAT Z daca nu e Z scriptul nu va merge.


#Getting the md5 of the file
md5=`md5sum $1 | awk '{ print $1 }'`
echo "md5 = "${md5}

# Explanations
# The name of he file to be scanned is md5_timestamp. The same name is
# used to create the folder /root/inputcamav/md5_timestamp. Therefore,
# the name of the file to be scanned is the same with the name of the
# folder  md5ofthefile+timestamp.


# Creating the md5 folder inside the INPUTFOLDER.
echo "Input folder = "$INPUTFOLDER
echo "The path where the scripts run = "
pwd
echo "Name of the folder where the folder is to be created = "$INPUTFOLDER$FOLDERNAME
mkdir $INPUTFOLDER$FOLDERNAME


# Explanations
# Copy the file to the place where is accessible to the VMs
# copy the file $1 (md5_timestamp) in a folder with the same name.
cp --preserve -v $1 $INPUTFOLDER$FOLDERNAME 

# Here STARTS the file processing, by writing in the db (activetask_av)
resultfile="/var/www/camav/tmp/res_"$FILETOBESCAN
cd $INPUTFOLDER$FOLDERNAME
echo "FOLDERNAME= "$FOLDERNAME
echo "resultfile= "$resultfile
activetaskid=`sed -n -e 's/.*<acta_av_id>\(.*\)<\/acta_av_id>.*/\1/p' $resultfile`
echo "activetaskid= "$activetaskid
echo "resultfile= "$resultfile

python /usr/local/camav/task_process_update.py $md5 $activetaskid
# Here ENDS the file processing, by writing in the db (activetask_av)
processing_main
processing_shutdown_machine
processing_file_manipulation
#	SCRIPT MAIN	=======================================================
#======================================================================
