<?php
/*
#=======================================================================
#
#		   FILE: is_file_done.php
#
# 		  USAGE: This is CAMAV PHP compoinent file
#
# 	DESCRIPTION: CAMAV - Multi Antivirus Engine
#				 This file checks if a scan is ready, and its results
#				 are in the db. If it's ready returns the results.
#				 
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
*/

include "camav_phpconf.php";
if ($host=="") 
{
	echo " the configuration file could not be loaded";
	exit("EXIT");
}

//ini_set('display_errors',1); 
// error_reporting(E_ALL);
 
 
 

$strMD5=@$_GET["hash"];
$strMD5 = trim($strMD5); 
$geti=$_GET["i"];
$actaav_id=$geti;

// connect to the database
$conn=mysql_connect($host,$username,$passwd); 

// select the db to be used
mysql_select_db("sandbox") or die("unable to select database"); 


 $query="SELECT * FROM `activetasks_av` WHERE actaav_md5=\"".$strMD5."\" AND actaav_id=".$actaav_id." order by actaav_firstSeen DESC LIMIT 1";


 $results=mysql_query($query);
 $numrows=mysql_num_rows($results);

if ($results)  // the result is 1, meaning it returned something
{
	 if ($numrows!= 0)  //case II something has been found in the table activetasks_av
	 {
		
		while ($row = mysql_fetch_assoc($results))
			{
				$actaav_active=$row['actaav_active'];
				$actaav_inserttime=$row['actaav_inserttime'];
				$actaav_procstarttime=$row['actaav_procstarttime'];
			}
		if ($actaav_active==1) // the task is active in the queue => waiting time has to be returned
		{
		 $newquery="SELECT * FROM `activetasks_av` WHERE actaav_inserttime<'".$actaav_inserttime."' AND actaav_endtime='1980-01-01 00:00:00' AND actaav_active=1";
		 $newresults=mysql_query($newquery);
		 $intTimeToWaitInTheQueue=0;
		 $intActiveTasksInQueue=0;
		 if ($newresults)
		 {
			$intActiveTasksInQueue=mysql_num_rows($newresults);
			if ($intActiveTasksInQueue!= 0) // there are tasks in the queue before the requested one
			{
				$intTimeToWaitInTheQueue=$intActiveTasksInQueue*240;
				$comeback_in_x_seconds=$intTimeToWaitInTheQueue+120;
				$resultII=$comeback_in_x_seconds."  ".$intActiveTasksInQueue." in the queue";
				echo $resultII;
			}
			else // there are NO tasks in the queue before the requested one
			{

				$actualtime=time();
				$actaav_procstarttime1=strtotime($actaav_procstarttime);
				
													
				if ($actaav_procstarttime=="1980-01-01 00:00:00")
				{
					$comeback_in_x_seconds=260;
				}
				else
				{
													
					$comeback_in_x_seconds=$actualtime-$actaav_procstarttime1;

					$comeback_in_x_seconds=240-$comeback_in_x_seconds;
				}
				$resultII=$comeback_in_x_seconds." in the queue ".$intActiveTasksInQueue;
				echo $resultII;
				
			} // else there are NO tasks in the queue before the requested one 
		 } //is new result 
		}
		else //else from if ($actaav_active==1) meaning the activa task==0
		{
			if ($actaav_active==0) //atunci cauta in tabela samples
			{
//HERE IS THE SEARCH INTO THE TABLE SAMPLES $actaav_active
					 $query = "SELECT * FROM `samples` WHERE sam_md5=\"".$strMD5."\" AND sam_id=".$actaav_id." order by sam_firstSeen DESC LIMIT 1 ";
					 
					 $results=mysql_query($query);
					 $numrows=mysql_num_rows($results);
					 if ($results)  // the result is 1 meaning something has been returned 
					{
					 if ($numrows!=0)  //case I - it has been found in the table samples
					 {
						while ($row = mysql_fetch_assoc($results))
							{
								$sam_md5=$row['sam_md5'];
								$sam_sha1=$row['sam_sha1'];
								$sam_id=$row['sam_id']; ///Maybe some conversion has to be done
								$sam_sha256=$row['sam_sha256']; 
								$sam_filename=$row['sam_filename'];
								$sam_filesize=$row['sam_filesize'];
							}				 

					
						mysql_free_result($results);
						//$$$$$$$$$$$$$$$$$$$$$$$$$$$$ A SECOND SEARCH - HERE THE RESULT IS SEARCHED IN THE TABLE detection $$$$$$$$$$$$$
						$query = "SELECT det_id, det_sam_id, det_name, det_time, det_result, av_name, av_version, det_av_update FROM ( SELECT * FROM detection WHERE det_sam_id =".$sam_id." ) AS detectionnew INNER JOIN antivirus ON detectionnew.det_av_id = antivirus.av_id";
						$results=mysql_query($query);
						$numrows=mysql_num_rows($results);
						 
						 // Check result
						// This shows the actual query sent to MySQL, and the error. Useful for debugging.
						if ($results) // the result is 1 meaning something has been returned 
						 {

							 
// This is the version which returs the result in a table (html table)								
								
								echo"<table width=\"98%\" class=\"dataTable\">";
								echo"  <thead>";
								echo"    <tr>";
								echo"      <td><b>Antivirus</b></td>";
								echo"      <td><b>Version</b></td>";
								echo"      <td><b>Last Update</b></td>";
								echo"      <td><b>Result</b></td>";
								echo"    </tr>";
								echo"  </thead>";
								echo"  <tbody>";
								
							    $intLineNumber=0;
								while ($row = mysql_fetch_assoc($results))
								{
									if( $odd = $intLineNumber%2 ) //check if it's odd or even to change the backgorund color of the row
										{
											echo"    <tr>";
										}
									else
										{
											 echo"    <tr style=\"background-color: #BEC8D1;\">";
										}
									//echo '      <td>'.$name["name"].'</td>';
									echo '      <td>'.$row['av_name'].'</td>';
									echo '      <td>'.$row['av_version'].'</td>';
									echo '      <td>'.$row['det_av_update'].'</td>';
									echo '      <td>'.$row['det_name'].'</td>';
									echo"     </tr>";
									$intLineNumber=$intLineNumber+1;
								}
								
								echo"    </tr>   ";
								echo"  </tbody>";
								echo"</table>";
							    //echo"</div>";


// HERE ENDS THE the version which returs the result in a table (html table)

/* JSON This is the version that returns the result as a JSON.... 

								$intLineNumber=0;
								$intDetections=0;
								while ($row = mysql_fetch_assoc($results))
								{
                                   $data["avres"][$intLineNumber][0]=$row['det_result'];
                                   if ($row['det_result']!="")
                                   {
										$intDetections++;
								   }
                                   $data["avres"][$intLineNumber][1]=$row['av_name'];
                                   $data["avres"][$intLineNumber][2]=$row['av_version'];
                                   $data["avres"][$intLineNumber][3]=$row['det_name'];
									$intLineNumber++;
								}
								$data["detected"]=$intDetections;
                                
                                $intNoofAntiviruses=$intLineNumber;
                                $floatPercentage=($intDetections*100)/$intNoofAntiviruses;
                                $strPercentage=number_format ($floatPercentage, 2);
                                $strPercentage=$strPercentage."%";
                                $data["total"]=$strPercentage;
								$jsonData = json_encode($data);
								
								echo   $jsonData;

//JSON HERE IT ENDS THE version that returns the result as a JSON.... */
							   
							} 							 
							else 
							{
								$message  = 'Invalid query: ' . mysql_error() . "\n";
							    $message .= 'Whole query: ' . $query;
							    die($message);
							} 
							mysql_free_result($results);						 
				
				}



// HERE ENDS THE SEARCH IN THE TABLE SAMPLES 
			
			}
		}


		mysql_free_result($results);
	  }
	}
		else //cazul III - the MD5 was not found, therefore I return 0 (the file has to be uploaded)
	{
	   echo "error";
	}
}

mysql_close($conn);					


?>
