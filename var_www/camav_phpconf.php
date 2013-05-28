<?php
#=======================================================================
#
#		   FILE: camav_phpconf.php
#
# 		  USAGE: This is camav PHP configuration file
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#				 Manages Virtual Machines with Antiviruses for
#				 VirtualBox guest machine.
#				 CAMAV Python configuration file;
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

#
# This is the main CAMAV Pyton configuration file.  It contains:
#
### Section 1: Global Environment
#
# The directives in this section affect the overall operation of 
# CAMAV Python (All python scripts running in CAMAV are configured
# by this script) such as database connections credentials, etc. 
#

#
# VBOXMANAGE: This is the path to the VirtualBox executable file
# 
# NOTE!  This path should be set to "/usr/bin/VBoxManage"
#
# Database connectivity credentials

$host="localhost";
$username = "root";
$passwd = "YOUR_PASSWORD_HERE";
$dbname = "sandbox";

?>
