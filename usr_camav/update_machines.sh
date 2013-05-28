#!/bin/bash
#=======================================================================
#
#		   FILE: update_machines.sh
#
# 		  USAGE: This file is used by the cron to update the machiens.
#				 It updates a particular machines or a list of machines
#				 separated by space.
#				 If no parameter is specified or -m without any
#				 machines names provided, all machines defined in
#				 configuration file camav.conf are updated.				 
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#				 This file is part of Camav processing engine.
#
#				 This file updates the Antivirus Virtual Machines.
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


#=======================================================================
#	LOCAL VARIABLES	====================================================

CONFIG_FILE="camav.conf"
BOOL_EXIT=
NAME_OF_THE_SCRIPT="`basename $0`"
#	END OF LOCAL VARIABLES	============================================
#=======================================================================

#=======================================================================
#	Configuration File	================================================

#-----------------------------------------------------------------------
#	Reading the configuration file. Maybe more checks need to be added 
#	to verify if the parameters are good
#-----------------------------------------------------------------------
if [[ -f $CONFIG_FILE ]]; then
        . $CONFIG_FILE
fi
#	END OF Configuration File	========================================
#=======================================================================

WITH_OR_WITHOUT_HEAD=""
if [ $HEAD -eq 0 ]
	then WITH_OR_WITHOUT_HEAD=" --type headless"
fi
echo $WITH_OR_WITHOUT_HEAD
#exit 0




#=======================================================================
#	FUNCTIONS	========================================================

#=== FUNCTION "log"=====================================================
#			NAME: log
#	 DESCRIPTION: Write the text in the log file.
#				  The log has the following format date | time | time zone | name of the program
#				  that generates the log | log line 
#				  E.g. 11-09-2012 14:39:42 +01:00 [update_machines.sh] Shutdown the machine
#	  PARAMETERS: Text to be log
#=======================================================================

log()
	{
	    message=`date +"%d-%m-%Y %T  %:z"`
	    message=$message" ["$NAME_OF_THE_SCRIPT"]"" $@"
	    echo  $message
	    echo $message >>$LOGFILE
	}
#===	END OF FUNCTION "log"	========================================



#=== FUNCTION "version"	================================================
#			NAME: version
#	 DESCRIPTION: Prints the script version. 
#	 PARAMETER 1: ---
#		   USAGE: version
#=======================================================================

version()
	{
	    echo "    "
	    echo "CAMAV - CART Multi Antivirus Engine"
	    echo "Manages Virtual Machines with Antiviruses for VirtualBox guest machine."
	    echo "    "
	    echo "This script is used for updating the machines and should be run from cron or manualy."
	    echo "    "
	    echo "Version: "$NAME_OF_THE_SCRIPT" Version 1.0 Build 11.09.2012"
		echo $NAME_OF_THE_SCRIPT" Version 1.0 Build 11.09.2012" >>$LOGFILE
	}
#===	END OF FUNCTION "version"	====================================


#=== FUNCTION "usage"	================================================
#			NAME: usage
#	 DESCRIPTION: Prints the usage of the script with all possible parameters
#	 PARAMETER 1: ---
#		   USAGE: usage
#=======================================================================

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
#===	END OF FUNCTION "usage"	========================================








#=== FUNCTION "update_prepare"==========================================
#			NAME: update_prepare
#	 DESCRIPTION: This function prepare the machine for the being
#				  updated. Actualy restore a known good snapshot,
#				  and then starts the machine, shut it down, restarts
#				  and shut it down again, to be prepared for the next
#				  startup when the update is done.  The update is done
#				  in the function update_main and update_chunks.
#		   USAGE: update_postprocess $NumberOfMachines
#	  PARAMETERS: The number of machines, therefore the stop count
#				  of the for instrunction. When there are 10 machines
#				  this parameter is 10
#=======================================================================

update_prepare()
{
		stop_count=$1
#-----------------------------------------------------------------------
#	Shut down all the machines gently.
#-----------------------------------------------------------------------
		log "#	Shut down all the machines gently..."
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		        # Shut down all the machines gently.
		        $VBOXMANAGE controlvm ${MACHINENAMES[$z]} acpipowerbutton 
				log "$VBOXMANAGE controlvm ${MACHINENAMES[$z]} acpipowerbutton"
		done
		sleep $SLEEPING_TIME
#-----------------------------------------------------------------------
#	If the machine are not shut down after 15 seconds I turn them off
#	brutally and restore the clean image.
#-----------------------------------------------------------------------
		log "#	Shut down all the machines brutaly..."
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		
		
		        #	if the machine are not shut down after 15 seconds
		        #	I turn them off brutaly
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$z]} poweroff"
		        $VBOXMANAGE controlvm ${MACHINENAMES[$z]} poweroff
		        
		                
		done
		
		log  "#	Restore the clean Image..."
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		        #	Restore the clean Image...
		        log "$VBOXMANAGE snapshot ${MACHINENAMES[$z]} restore clean1"
		        $VBOXMANAGE snapshot ${MACHINENAMES[$z]} restore clean1
		                        
		done
		
		log "#	Startup the machines..."
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		   
		        #Startup the machines...
		        $VBOXMANAGE startvm ${MACHINENAMES[$z]} $WITH_OR_WITHOUT_HEAD
		        log "$VBOXMANAGE startvm ${MACHINENAMES[$z]} $WITH_OR_WITHOUT_HEAD"
		                
		done
		
		log "#	Shut down all the machines gently..."
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		        #	Shut down all the machines gently.      
		        $VBOXMANAGE controlvm ${MACHINENAMES[$z]} acpipowerbutton
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$z]} acpipowerbutton"      
		done
#-----------------------------------------------------------------------
#	Waiting the machines to turn off
#-----------------------------------------------------------------------
		log "#	Waiting the machines to turn off | sleep 15"
		sleep $SLEEPING_TIME
		
		##	Turn off all the machines using shutdown, then boot up
		##	the machines
		log "#	Turn off all the machines using shutdown, then boot up the machines"
		
		log "#	If the machine are not shut down after 15 seconds I turn them off brutally"
		for (( z = 0 ; z < $stop_count ; z++ ))
		do
		
		        #	if the machine are not shut down after 15 seconds
		        #	I turn them off brutally
		        $VBOXMANAGE controlvm ${MACHINENAMES[$z]} poweroff                
				log "$VBOXMANAGE controlvm ${MACHINENAMES[$z]} poweroff"
		done
		sleep $SLEEPING_TIME
}
#===	END OF FUNCTION "update_prepare"	============================





#=== FUNCTION "update_chunks"===========================================
#			NAME: update_chunks
#	 DESCRIPTION: This function has as parameters the starting and ending 
#				  masines that have to be updated (0,3). THis means that
#				  the machine from the global variable MACHINES, 
#				  MACHINES[0], MACHINES[1], MACHINES[2] will be updated
#				  Privious to the call of this functions the machines
#				  have been prepared for this operation by the function
#				  update_prepare.
#		   USAGE: update_chunks $start $stop
#	  PARAMETERS: starting index, stoping index
#=======================================================================
update_chunks()
{
		#	Boot up  all the machines to allow them to make the
		#	updates in normal way and then turn them off

		log "#	First CHUNK"
		log "#	Boot up  all the machines to allow them to make the updates in normal way and then turn them off"
		
		from_count=$1
		to_count=$2	
		log "#	Startup the machines..."
		for (( j = $from_count ; j < $to_count; j++ ))
		do
		        #Startup the machine.
		        $VBOXMANAGE startvm ${MACHINENAMES[$j]} $WITH_OR_WITHOUT_HEAD
		        log "$VBOXMANAGE startvm ${MACHINENAMES[$j]} $WITH_OR_WITHOUT_HEAD"
		done
		
		log "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Here it is the waiting time for updateting the machines"
		
#-----------------------------------------------------------------------
#	Sleep 30 minutes
#-----------------------------------------------------------------------
		log "#	Sleep $WAITING_TIME/60 minutes | sleep $WAITING_TIME"
		sleep $WAITING_TIME
		
#-----------------------------------------------------------------------
#	Turn off the machines gently.
#-----------------------------------------------------------------------
		log "#  Turn off the machines gently."
		
		log "#	Shut down all the machines gently..."
		for (( j = $from_count ; j < $to_count ; j++ ))
		do
		
		        #	Shut down all the machines gently.
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[j]} acpipowerbutton"
		        $VBOXMANAGE controlvm ${MACHINENAMES[j]} acpipowerbutton
		                
		done
#-----------------------------------------------------------------------
#	Waiting for the machines to turn off | sleep 15
#-----------------------------------------------------------------------
		log "Waiting for the machines to turn off | sleep 15"
		sleep $SLEEPING_TIME
		
#-----------------------------------------------------------------------
#	Turn off all machines using shutdown (brutaly)
#-----------------------------------------------------------------------
		log "#	Turn off all machines using shutdown (brutaly)"
		
		for (( j = $from_count ; j < $to_count ; j++ ))
		do
		
		        #	if the machine are not shut down after 15 seconds
		        #	I turn them off brutally/
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$j]} poweroff "
		        $VBOXMANAGE controlvm ${MACHINENAMES[$j]} poweroff                
		done
		
		sleep $SLEEPING_TIME
}
#===	END OF FUNCTION "update_chunks"	================================





#=== FUNCTION "update_main"=============================================
#			NAME: update_main
#	 DESCRIPTION: This function update the machines provided in the
#				  the array MACHINENAMES. This variable is normaly
#				  loaded from the config file. The script could update
#				  only one machine or a list of machines when this are
#				  provided as parameter for the script. e.g using
#				  parameter -m. When list of machines are provided, the
#				  MACHINENAMES variable will be overwritten. This
#				  function manage the number of machines to be updated.
#		   USAGE: update_main
#	  PARAMETERS: ---
#=======================================================================


#-----------------------------------------------------------------------
#	Comment: 
#	The logic of the script is the following:
#	All machines needs to be updated. The number of machines is by this
#	time 10. I can not allow all machines to run in the same time due to
#	performance constrains. Therefore, I start up calups of 3 or 4
#	machines at one time (UPDATE_CHUNKS), to allow them to update in
#	paralel. The number of machines to be updated at one time is a
#	global variable in the camav.conf UPDATE_CHUNKS.
#	Therefore I count the number of machines that needs to be updated.
#	Divide this number with the UPDATE_CHUNKS (3) to get the number of
#	update cycles to follow. The modulus (the machines that left over)
#	will updated in a separate partial cycle that will be conditioned by
#	the	value of the modulusbe added to the first cycle.
#	E.g. We have 10 machines and therefore we will have 3 cycles
#		1st cycle of 3 
#		2nd cycle of 3
#		3rd cycle of 4
#	The algoritm is the folloing:
#	NumberOfMachines=${#MACHINENAMES[@]}
#	let MODULUS=$NumberOfMachines%3
#	let NumberOfUpdateCycles=$NumberOfMachines/3
#	startcount=0
#	stopcount=startcount+UPDATE_CHUNKS
#	
#	for (i=0;i<$NumberOfUpdateCycles;i++)
#	{
#		for (j=startcount;j<stopcount;j++)
#		 {
#			update the machines 
#		 }
#		startcount=stopcount
#		stopcount=stopcount+UPDATE_CHUNKS
#	}
#	if (modulus!=0)
#	{
#		stopcount=startcount+modulus
#		for (j=startcount;j<stopcount;j++)
#		 {
#			update the machines 
#		 }
#	}
#
#-----------------------------------------------------------------------

update_main()
{
		NumberOfMachines=${#MACHINENAMES[@]}
		
		update_prepare $NumberOfMachines #call update_prepare
		
		echo $NumberOfMachines
		let MODULUS=$NumberOfMachines%$UPDATE_CHUNKS
		echo "$NumberOfMachines % $UPDATE_CHUNKS =" $MODULUS
		
		
		let NumberOfUpdateCycles=$NumberOfMachines/$UPDATE_CHUNKS
		echo "$NumberOfMachines / $UPDATE_CHUNKS =" $NumberOfUpdateCycles
		
		let startcount=0
		stopcount=$startcount+$UPDATE_CHUNKS
		
		
		for (( i = 0 ; i < $NumberOfUpdateCycles; i++ ))
			do
		
				update_chunks $startcount $stopcount #call update_chunks
				startcount=$stopcount
				stopcount=$stopcount+$UPDATE_CHUNKS
		
			done
		
		if [ $MODULUS -ne 0 ]
		then
			stopcount=$startcount+$MODULUS
			update_chunks $startcount $stopcount
		fi
		
		update_postprocess $NumberOfMachines #call update_postprocess
}
#===	END OF FUNCTION "update_main"	================================


#=== FUNCTION "update_postprocess"======================================
#			NAME: update_postprocess
#	 DESCRIPTION: This function shutdown the updated machines, and
#				  creats snapshots of the newly updated machines and
#				  detele the old one. 
#		   USAGE: update_postprocess $NumberOfMachines
#	  PARAMETERS: The number of machines, therefore the stop count
#				  of the "for" instrunction. When there are 10 machines
#				  this parameter is 10
#=======================================================================

update_postprocess()
{

		stop_count=$1

#### Basically by this time all the machines should be updated,
#### therefore I restart all machines and then I take the new snapshots

#	Shut down all the machines gently.
		log "#Shut down all the machines gently"
		for (( t = 0 ; t < $stop_count ; t++ ))
		do
		
				#	Shut down all the machines gently.
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$t]} acpipowerbutton"
		        $VBOXMANAGE controlvm ${MACHINENAMES[$t]} acpipowerbutton
		
		done
		sleep $SLEEPING_TIME

#-----------------------------------------------------------------------
#	If the machine are not shut down after 15 seconds I turn them off
#	brutally and restore the clean image.
#-----------------------------------------------------------------------
		for (( t = 0 ; t < $stop_count ; t++ ))
		do
		
		        #	if the machine are not shut down after 15 seconds I
		        #	turn them off brutally/
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$t]} poweroff"
		        $VBOXMANAGE controlvm ${MACHINENAMES[$t]} poweroff
		done
		
		log "#	Startup the machine..."
		for (( t = 0 ; t < $stop_count ; t++ ))
		do        
		        #	Startup the machine...
		        $VBOXMANAGE startvm ${MACHINENAMES[$t]} $WITH_OR_WITHOUT_HEAD
		        log "$VBOXMANAGE startvm ${MACHINENAMES[$t]} $WITH_OR_WITHOUT_HEAD"                
		done
#-----------------------------------------------------------------------
#	Waiting for the machines to start | sleep 120.
#-----------------------------------------------------------------------
		log "# Waiting for the machines to start | sleep 120"
		
		#sleep 120
		sleep 480 
 		###########################################
		
		for (( t = 0 ; t < $stop_count ; t++ ))
		do
		
		        #	This has been done to overcome the know bug of not
		        #	taking snapshots when the machine is running.
		        #	therefore before taking the snapshot the machine is
		        #	paused first. This is for the VBox 4.1.6 74713
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$t]} pause"
		        $VBOXMANAGE controlvm ${MACHINENAMES[$t]} pause
		
		
		        #	Take a snapshot...
		        log "$VBOXMANAGE snapshot ${MACHINENAMES[$t]} take clean2"
		        $VBOXMANAGE snapshot ${MACHINENAMES[$t]} take clean2
		        sleep $SLEEPING_TIME
		        
		        #	If the machine are not shut down after 15 seconds
		        #	I turn them off brutally.
		        log "$VBOXMANAGE controlvm ${MACHINENAMES[$t]} poweroff"
		        $VBOXMANAGE controlvm ${MACHINENAMES[$t]} poweroff
		        
		        #	Renaming old snapshot...
		        log "#	Renaming old snapshot..."
				$VBOXMANAGE snapshot ${MACHINENAMES[$t]} edit clean1 --name deleteme
				log "$VBOXMANAGE snapshot ${MACHINENAMES[$t]} edit clean1 --name deleteme"
				sleep $SLEEPING_TIME
				
				#	Renaming current snapshot...
				log "#	Renaming current snapshot..."
				$VBOXMANAGE snapshot ${MACHINENAMES[$t]} edit clean2 --name clean1
				log "$VBOXMANAGE snapshot ${MACHINENAMES[$t]} edit clean2 --name clean1"
				sleep $SLEEPING_TIME

				#	Deleting old snapshot...
				log "#	Deleting old snapshot..."
				$VBOXMANAGE snapshot ${MACHINENAMES[$t]} delete deleteme
				log "$VBOXMANAGE snapshot ${MACHINENAMES[$t]} delete deleteme"
		               
		done
}

#===	END OF FUNCTION "update_postprocess"	========================



#=== FUNCTION "list_of_machines"	====================================
#			NAME: list_of_machines
#	 DESCRIPTION: This function takes the parameter after the
#				  -m parameter, to overwrite the global variable
#				  MACHINENAMES with the list provided after the
#				  parameter. E.g. update_maV2 -m avso avav This function
#				  should put the names of two machines in the variable
#				  MACHINENAMES={avso,avav}
#	  PARAMETERS: The list of parameter that the string has receive
#=======================================================================

list_of_machines()
	{
	    local script_parameters=(${@})
	    echo ${script_parameters[*]}
	    local str_script_parameters=$@
	    if [ "$str_script_parameters" != "" ]
		then
		    MACHINENAMES=('')
		    MACHINENAMES=(${script_parameters[@]})
		    log "# The machines have been provided in the command line ..." 
		    
		else
			log "# No machines have been provided; all machine will be updated..." 
		fi
		log "# The machines to be updated are... ${MACHINENAMES[*]}"

	    # exit 0
	    #message=`date +"%d-%m-%Y %T  %:z"`
	    #message=$message" ["$NAME_OF_THE_SCRIPT"]"" $@"
	    #echo  $message
	    #echo $message >>$LOGFILE
	}
#===	END OF FUNCTION "list_of_machines"	============================




#	END Of Functions	================================================
#=======================================================================




#=======================================================================
#=====	SCRIPT MAIN	====================================================

#-----------------------------------------------------------------------
# 	V1.1 Comment
#	This is the MAIN part of the script where parameter are processed.
#-----------------------------------------------------------------------



args=("$@[*]")
#echo ${args[0]} ${args[1]} ${args[2]} #' -> args=("$@"); echo ${args[0]} ${args[1]} ${args[2]}'
#while [ $# -gt 0 ]
#do
  case $1 in
    "-v") version
        shift
        exit 0
        ;;
    "-h") usage
        shift
        exit 0
        ;;
    "-m") 
		shift
		cd /root/inputcamav/
		list_of_machines $@
		shift ;; ## ignore other arguments
    "") 
		cd /root/inputcamav/
		list_of_machines
		shift ;; ## ignore other arguments
	*) 
		echo "Unknown parameter... please use $0 -h for help"
		usage
		shift
		exit 0
		;; ## ignore other arguments
		
  esac
#done
#echo ${MACHINENAMES[*]}

#exit 0

#	SCRIPT MAIN	========================================================
#=======================================================================


update_main # call update_main function
