<html>
  <head>
    <title>Camav ::: File Upload</title>
      <link href="styles2.css" rel="styleSheet" type="text/css">
      <link href="per.css" rel="styleSheet" type="text/css">
      <link href="css.css" rel="styleSheet" type="text/css">
<script src="jquery-1.6.2.js" language="javascript" type="text/javascript"> </script>
<script language="javascript" type="text/javascript">



function checkFile(hashmd5){
       $.ajax({
               url: "is_file_done.php",
               data:"hash="+hashmd5+"&"+Math.random(), //the random has been added to overcome the fact that success was never triggered in IE because IE keep the result of the first interogation. Here we force it to recall.
               success: function(returnValue){
					   //alert(returnValue);
					   t=returnValue.indexOf("in the queue");
                       //alert(t);
                       x=Number("-1");
                       if(t==x){//presupun ca is_file_done.php?md5=eswtqe452tergftqwer va intoarce textul "0" (fara ghilimele) daca fisierul nu e  gata inca. Deci daca e diferit de "0" am fisierul produs si pot face ce vreau cu el
                               //alert('amu o intrat in bucla aici');
                               //alert(returnValue);
                               $('#AVResult').html("");
                               $('#AVResult').append(returnValue);
                               $('#processinggif').html("<span class='text-normal'>Finalised</span>");
                       } else 
                       {
                               $('#processinggif').html("<div id='processinggif'><span class='text-normal'><img src='upload_resume_progress_bar.gif'> &nbsp;&nbsp;&nbsp;Processing....</span></div>");
                               setTimeout(function(){checkFile(hashmd5)},20000);//va apela checkFile in 20 secunde pentru ca fisierul inca nu este disponibil

                              // checkFile(localMd5);
                       }
               },
               error: function(){
                       //aici cand am eroare (de exemplu i-a picat netul omului)
               },
               complete:function(){
                       //aici scriu cod care vreau sa fie executat dupa success sau error
               }
       });
       
}

</script>
</head>

  <div id="tipbox_iframe" class="tipbox">
  </div>

  <body>
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
      <tr>
        <td>
 
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="no-margin">
  <tr>
    <td width="215" valign="bottom" rowspan="3" class="banner-color">
        <img src="logo+background.gif" height="68" width="215" border="0" alt="logo">
    </td>
    
<td><table class="no-margin" cellSpacing="0" cellPadding="0" width="100%" border="0"><tr>
    <td height="30" valign="top" class="banner-color">
      <span class="text-smallest-bold" style="color:white;">
        &nbsp; ::
      </span>
    </td>

   <td align="right" valign="center" class="banner-color" nowrap>
  	<span><a href=# style="color:white;text-decoration:underline;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;font-weight:normal;">Privacy statement</a></span>&nbsp;
  </td>
</tr></table></td>
    
  </tr>
  <tr>
  	<td>
	  <table width="100%" cellpadding="0" cellspacing="0">
	    <tr>
          <td valign="top" height="19" width="100%" class="banner-color">
			
          </td>
          <td valign="top" width="49" class="banner-color">
            <img src="pente-trans.gif" width="49" height="19">
          </td>
		  <td align="right">
			<table width="100%" cellpadding="0" cellspacing="0">
		      <tr>
	          
				<td valign="top" class="francais-cell">
                      <a href="#" class="language">&nbsp;Français&nbsp;</a>
                </td>

						<td valign="top" class="deutsch-cell">
                          
                            <a href="#" class="language">&nbsp;Deutsch&nbsp;</a>
                          
                        </td>
			  </tr>
			</table>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
  <tr bgcolor="006699">
  	<td>
	  <table width="100%" cellpadding="0" cellspacing="0">
	    <tr>
		  <td valign="middle" height="19" bgcolor="006699" class="context-bar" width="100%">
		    
			  
			    <span class="context-no-link">&nbsp;-&gt;</span>&nbsp;
					  <a href="main.htm" class="context-link">Menu</a>
			    <span class="context-no-link">&nbsp;-&gt;</span>&nbsp;
				  <span class="context-no-link">&nbsp;
				    <font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">
                      File Upload
				    </font>
				  </span>
	      </td>
	      <td>
		    <table width="100%" cellpadding="0" cellspacing="0">
		      <tr>
				<td valign="middle" class="contact-help-bar">
			      <span align="center" class="contact-link">
                    
                    
			            <a href="#" target="_blank" class="contact-link">&nbsp;&nbsp;contact&nbsp;&nbsp;</a>
                    
                    
	  		      </span>
				</td>
				<td valign="middle" class="contact-help-bar">
			      <span align="center" class="contact-link">
                   
			  	    <a href="#" class="contact-link">&nbsp;&nbsp;help&nbsp;&nbsp;</a>
                   
	  		      </span>
				</td>
				<td valign="middle" class="contact-help-bar">
			      <span align="center" class="contact-link">
			  	    <a href="#" target="_top" class="contact-link" onclick="return confirmLogoff();">&nbsp;&nbsp;logout&nbsp;&nbsp;</a>
	  		      </span>
				</td>
		      </tr>
			</table>
	      </td>
	    </tr>
      </table>
    </td>
  </tr>
</table>

        </td>
      </tr>
      <tr>
        <td>
          



<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr><td height="10"></td></tr>
  
  <tr>
    <td>
      <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr><td height="10"></td></tr>
        <tr>
          <td>
            


  <table class="tabs_level_1" cellspacing="0" cellpadding="0"><tbody>
      <tr>
		
          <td>
    
	            
<div class="selected" id="">
  File Upload
</div>
          </td>
      </tr>
</tbody></table>

          </td>
        </tr>
        <tr id="">
          <td class="background-color-level-1">
           
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr><td height="10"></td></tr>
  <tr>
	<td>
      
	</td>
  </tr>
  <tr>
    <td>
      <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr><td height="10"></td></tr>
        <tr id="level_2">
          <td class="background-color-level-2">
 
<div class="box">

<form id="searchForm" ACTION="upload_file.php" method="POST" enctype="multipart/form-data">


<input type="hidden" name="perId" value="36875">
<input type="hidden" name="viewDate" value="">
<input type="hidden" name="loadFlag" value="false">

 <table border="0" width="100%" id="table1">
	<tr>
		<td width="0%"> <img src="fleche_ok.gif" width="10" height="8"></td>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="33%"><span class="title-small" style="vertical-align: middle;">File Upload</span></td>		
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>
	</tr>
	<tr>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="33%">
		<input type=FILE name="file" size=17 style="width: 1.75in; height: 0.24in">

		</div></div></td>
		<td width="33%">&nbsp;</td>
		<td width="33%"></td>
		<td width="33%"></td>					
	</tr>
	<tr>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="33%"><input type="Submit" name="btnSubmitFile" value="Upload" class="approve" align=right /></td>
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>				
	</tr>
		<tr>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="0%">&nbsp;</td>
		<td width="33%">&nbsp;</td>		
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>
		<td width="33%">&nbsp;</td>
	</tr>
</form>

<?php
include "camav_phpconf.php";
if ($host=="") 
{
	echo " the configuration file could not be loaded";
	exit("EXIT");
}

ini_set('display_errors',1); 
 error_reporting(E_ALL);

$desters="/var/www/camav/upload/res_2b62211b8c0ba29c5920e77d16129ae2";
$pathtoFile="/var/www/camav/upload/";
$pathFS="/opt/f-secure/fssp/bin/fsav";
$pathCLAMAV="/usr/bin/clamscan";
$pathSOPHOS="/opt/sophos-av/bin/savscan";
$pathMcAfee="/opt/mcafeecli/uvscan";
$booFilemoved=0;
$intInfected=0;
$strfile_is_uploaded="O.k";
$strProcessingStatus="Starting...";
$intSomeError=0;
$intSizeOfThePOST=0;

/*the if the uploaded file is bigger than POST_MAX_SIZE (php.ini) the post is droped therefore, I can not check the file size.
 Here I check the size of the post before anything else. If the size of the post is exceeded I will show the message that the maximum 
 upload size is 4 MB*/

// if the initial page is showed there is no post therefore the variable $_SERVER['CONTENT_LENGTH']) is not INTIATED
//To avoid this trouble we use the variable $intSizeOfThePOST. THis variable will be initialy set to 1. Then if the variable
//$_SERVER['CONTENT_LENGTH']) is set the $intSizeOfThePOST will get the value of $_SERVER['CONTENT_LENGTH'])
// This is to avoid the usage of uninitiated variable $_SERVER['CONTENT_LENGTH'])
$POST_MAX_SIZE = ini_get('post_max_size');
$mul = substr($POST_MAX_SIZE, -1);
$mul = ($mul == 'M' ? 1048576 : ($mul == 'K' ? 1024 : ($mul == 'G' ? 1073741824 : 1)));
if (isset($_SERVER['CONTENT_LENGTH']))
{
	$intSizeOfThePOST=$_SERVER['CONTENT_LENGTH'];
	//echo "variabila setata";
	//echo $_SERVER['CONTENT_LENGTH'];
}

if ($intSizeOfThePOST > $mul*(int)$POST_MAX_SIZE && $POST_MAX_SIZE)
{
	$intSomeError=1;
	$strfile_is_uploaded="ERR: NOT UPLOADED";
	$strProcessingStatus="File Size Exccedded " .$intSizeOfThePOST ." Max 4Mb"; 
	//echo "error";
}
else //adica daca post-ul e mai mic decat post_max_size se face urmatoarea procesare (post max size =8M and max upload=4) asadar tot ceea ce e inbetween, va fi tratat de catre max file size
{

	$intUploadBtnPushed=0;
	//variable used to see if the upload button was pushed or not. depending on this I'am searching for the result file, or I do show 
	// only the upload form
	if(isset($_POST["btnSubmitFile"]))
	{
		$intUploadBtnPushed=1;
	}
	else
	{
		$intUploadBtnPushed=0;
	}
	if ($intUploadBtnPushed==1)
	{

		if (!is_uploaded_file($_FILES['file']['tmp_name'])) //if the file was not updated
		 {
			$intSomeError=1;
			$strfile_is_uploaded="ERR: NOT UPLOADED";
			$strProcessingStatus="ERR: No file to process";
			//echo "File ". $_FILES['file']['name'] ." NOT uploaded successfully.\n";
			//echo "Possible file upload attack: ";
			//echo "filename '". $_FILES['file']['tmp_name'] . "'.";

			if ($_FILES["file"]["error"]==1) //if return error is 1 ; The uploaded file exceeds the upload_max_filesize directive in php.ini
			{
				$strfile_is_uploaded="ERR: NOT UPLOADED";
				//$strProcessingStatus="File Size Exccedded Max 4Mb"; 
				$strProcessingStatus="File Size Exccedded " .$intSizeOfThePOST." Max 4Mb"; 

					/*
					UPLOAD_ERR_OK           Value: 0; There is no error, the file uploaded with success.
					UPLOAD_ERR_INI_SIZE     Value: 1; The uploaded file exceeds the upload_max_filesize directive in php.ini.
					UPLOAD_ERR_FORM_SIZE    Value: 2; The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form.
					UPLOAD_ERR_PARTIAL      Value: 3; The uploaded file was only partially uploaded.
					UPLOAD_ERR_NO_FILE      Value: 4; No file was uploaded.
					UPLOAD_ERR_NO_TMP_DIR   Value: 6; Missing a temporary folder. Introduced in PHP 4.3.10 and PHP 5.0.3.
					UPLOAD_ERR_CANT_WRITE   Value: 7; Failed to write file to disk. Introduced in PHP 5.1.0.
					UPLOAD_ERR_EXTENSION    Value: 8; A PHP extension stopped the file upload. PHP does not provide a way to ascertain which extension caused the file upload to stop; examining the list of loaded extensions with phpinfo() may help. Introduced in PHP 5.2.0.
					*/			
			}
		 }
		else //else of if the file was not updated ...meaning the file was updated
		{
		   $strfile_is_uploaded="O.k";
		   //echo "File ". $_FILES['file']['name'] ." uploaded successfully.\n";
		   //   echo "Displaying contents\n";
		   //   readfile($_FILES['file']['tmp_name']);

		 
			if ($_FILES["file"]["size"] < 4000000)
			{

				if ($_FILES["file"]["error"] > 0)
				{
					$intSomeError=1;
					$strfile_is_uploaded="ERR: NOT UPLOADED";
					$strProcessingStatus="ERR: Ret Code: " . $_FILES["file"]["error"] . "";
					echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
				}
				else
				{
					///////////////// calculates the MD5 while it is still in /tmp/filename 
					
					$strMD5 = md5_file($_FILES["file"]["tmp_name"]);
					$strSHA1 = sha1_file($_FILES["file"]["tmp_name"]);
					$strSHA256 = hash_file('sha256', $_FILES["file"]["tmp_name"]);
					/////////////////END OF  MD5 /////////////////////////////////////////
					
					// AICI MUT FISIERUL uploadat de php care se gaseste in /tmp/randomfilename in /var/www/camav/upload/md5
					//practic pastre fisierul uploadat avand ca nume md5-ul lui +time stampul la care a fost uploadat
					//fisierul va arata practic md5_timestamp
					
					$queueSystem_timestamp = date("YmdHis"); //anul luna ziua ora minutul secunda
					$queueSystem_FileName = "";
					$queueSystem_FileName = $queueSystem_FileName."queue/".$strMD5."_".$queueSystem_timestamp;

					if (move_uploaded_file($_FILES["file"]["tmp_name"],"upload/". $strMD5."_".$queueSystem_timestamp))
					{
						$booFilemoved=1;


						
						//############Aici ar trebui sa fie bucata cu inserarea in BD##################################
						
						//EXPLICATIE...
						/* Un fisier uploadat la o data x poate sa fie in urmatoarele stari
						1 uploadat si analizat -> inseamna ca se gaseste in tabela samples
						2 uploadat si in curs de analizare -> inseamna ca se gaseste in tabela activetasks_av si are campul "activ"=1
						3 nu a fost inca uploadat, si atunci trebe uploadat.
						 
						In momentul in care se uploadeaza un fisier, pun in bd samples tabela activetasks_av datele de identificare.
						in momentul in care termin task-ul updatez tabela activetasks_av cu campurile actaav_endtime a carui noua valoare va fi
						data si ora cand s-o temrinat task-ul si campul  active care va trece din 1 in 0.
						Valoarea default a campului actaav_endtime este "1970-01-01 00:00:00";
						*/
						
						//connect to your database *
						
						
						$conn=mysql_connect($host,$username,$passwd); //(host, username, password)
						
						//specify database ** EDIT REQUIRED HERE **
						mysql_select_db($dbname) or die("Unable to select database"); //select which database we're using

//Verifica daca nu cumva mai exista un task activ cu acelasi md5
//daca exista ...afisez ceva de genul fisierul a mai fost uploadat, please use the search functionality in coulpe of minutes.

						$query="SELECT * FROM `activetasks_av` WHERE actaav_md5=\"".$strMD5."\" and `actaav_endtime`='1980-01-01 00:00:00' and `actaav_active`=1";
						$results=mysql_query($query);
						$numrows=mysql_num_rows($results);
						if ($results)  //rezultatul e 1 adica o intors ceva
							{
								if ($numrows!=0)  //cazul I am gasit in tabela samples
								{
								   die("File is processing, use the search functionality.");
								}
							}


						// Build SQL Query  									
						$actaav_inserttime=date("Y-m-d H:i:s");

						//cat timp task-ul e activ, pun actaav_endtime 1 ianuarie 1980 00 00 00

						$actaav_endtime="1980-01-01 00:00:00";
						$actaav_active=1;
						$actaav_procstarttime="1980-01-01 00:00:00"; //cat timp tnu stiu cand va fi procesat pun actaav_procstarttime 1 ianuarie 1980 00 00 00
						$actaav_ip=getenv('REMOTE_ADDR');
						$actaav_filetype_id="1";
						$actaav_firstSeen=date("Y-m-d");
						$query="INSERT INTO `".$dbname."`.`activetasks_av` (`actaav_id`, `actaav_md5`, `actaav_sha1`, `actaav_sha256`, `actaav_filename`, `actaav_filesize`, `actaav_firstSeen`, `actaav_filetype_id`, `actaav_path`, `actaav_ip`, `actaav_inserttime`, `actaav_procstarttime`, `actaav_endtime`, `actaav_active`) VALUES (NULL, \"".$strMD5."\", \"".$strSHA1."\", \"".$strSHA256."\", \"".$_FILES['file']['name']."\", \"".$_FILES['file']['size']."\", \"".$actaav_firstSeen."\", ".$actaav_filetype_id.", \"path\", \"".$actaav_ip."\", \"".$actaav_inserttime."\", \"".$actaav_procstarttime."\", \"".$actaav_endtime."\", \"".$actaav_active."\")";
						$results=mysql_query("BEGIN");
						$results=mysql_query($query);
						$intActiveTask_av_Id=mysql_insert_id();
						//echo "INIT SAMPLEID ";
						//echo $intSampleId; 

						if (mysql_error())
							mysql_query("rollback");
						else
							mysql_query("commit");


						#$output=shell_exec("python /var/www/camav/queue_put.py ". $strMD5."_".$queueSystem_timestamp);
						$strque_filename= $strMD5."_".$queueSystem_timestamp;
#########################
						$query="INSERT INTO `".$dbname."`.`queue` (`que_id`, `que_md5`, `que_sha1`, `que_filename`, `que_filesize`, `que_timequeue`, `que_timeout`, `que_priority`, `que_uid`, `que_ip`, `que_task_type`, `que_locked`) VALUES (NULL, \"".$strMD5."\",\"".$strSHA1."\",\"".$strque_filename."\",\"".$_FILES['file']['size']."\", CURRENT_TIMESTAMP, '10minutes', '1', '', '', '0', '0')";
						$results=mysql_query("BEGIN");
						$results=mysql_query($query);
						$intque_id=mysql_insert_id();
						if (mysql_error())
							mysql_query("rollback");
						else
							mysql_query("commit");

#########################

						mysql_close($conn);
									
						//##############################################

						

						
						// CREATION OF THE XML FILE WITH FILE DETAILS
						//the file details are stored into a xml files. The later processing will add detection information to the xml file res_md5...
						
						// create doctype

						$dom = new DOMDocument("1.0");
						
						// create root element
						$root = $dom->createElement("fileinfo");
						$dom->appendChild($root);
						$dom->formatOutput=true;
						
						/*
						<sam_md5></sam_md5>
						<sam_sha1>90df847611c9f661b5c89e5a739cc4e217db9c4b</sam_sha1>
						<sam_sha256>90df847611c9f661b5c89e5a739cc4e217db9c4b</sam_sha256>
						<sam_filename>fisier.txt</sam_filename>
						<sam_filesize>123</sam_filesize>
						<sam_firstSeen>2011-08-24</sam_firstSeen>
						<sam_filetype_id>2</sam_filetype_id>
						<sam_path>/var/www/camav/</sam_path>
						<sam_ip>192.168.1.1</sam_ip>
						<acta_av_id>44</acta_av_id>
						</fileinfo>
						*/
												
					
						// create child element md5
						$item = $dom->createElement("sam_md5");
						$root->appendChild($item);
						
						// create text node
						$text = $dom->createTextNode($strMD5);
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_sha1");
						$root->appendChild($item);
						
						// create text node
						$text = $dom->createTextNode($strSHA1);
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_sha256");
						$root->appendChild($item);
						
						// create text node
						$text = $dom->createTextNode($strSHA256);
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_filename");
						$root->appendChild($item);
						
						// create text node
						$text = $dom->createTextNode($_FILES['file']['name']);
						$item->appendChild($text);
						

						// create child element
						$item = $dom->createElement("sam_filesize");
						$root->appendChild($item);
						
						// create text node
						$text = $dom->createTextNode($_FILES['file']['size']);
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_firstSeen");
						$root->appendChild($item);
						
						// create text node
						//$today = date("d/m/y");
						$today = date("Y-m-d H:i:s");
						$text = $dom->createTextNode($today);
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_filetype_id");
						$root->appendChild($item);
						
						// create CDATA section the "file" output command
						//$cdata = $dom->createCDATASection("\nHERE SHOULD BE THE FILE COMMAND OUTPUT\n");
						//$root->appendChild($cdata);
						
						//THIS IS DEFAULT VALUE AND CONSTANT ..NEEDS TO BE REVIEW
						// create text node
						$text = $dom->createTextNode("1");
						$item->appendChild($text);
						
						// create child element
						$item = $dom->createElement("sam_ip");
						$root->appendChild($item);
						
						// create text node
						$ip = getenv('REMOTE_ADDR');
						$text = $dom->createTextNode($ip);
						$item->appendChild($text);
						
						
					
					//aici tin ID_ul inserat in tabela ACTIVETASK_AV, ca sa stiu ce sa updatez later.	
						$item = $dom->createElement("acta_av_id");
						$root->appendChild($item);
					
						$text = $dom->createTextNode($intActiveTask_av_Id);
						$item->appendChild($text);

						
						
						
						
						// create attribute node
						//$price = $dom->createAttribute("price");
						//$item->appendChild($price);
						
						// create attribute value node
						//$priceValue = $dom->createTextNode("4");
						//$price->appendChild($priceValue);
						
						// create CDATA section
						//$cdata = $dom->createCDATASection("\nCustomer requests that pizza be sliced into 16 square pieces\n");
						//$root->appendChild($cdata);
						
						// create PI
						//$pi = $dom->createProcessingInstruction("process", "show()");
						//$root->appendChild($pi);
						
						//save the file to /var/www/camav/tmp/res_md5 THIS FILE WILL BE LATER PROCESSED by the upanddown.sh script which
						//will add the result of the scanning.
						// save tree to file
						//$strResultFile="/var/www/camav/tmp/res_".$strMD5;
						$strResultFile="/var/www/camav/tmp/res_".$strMD5."_".$queueSystem_timestamp;
						//echo $strResultFile; 
						$dom->save($strResultFile);
						//echo 'Wrote: ' . $dom->save("/var/www/camav/upload/order.xml") . ' bytes'; // Wrote: 72 bytes
						
						// save tree to string
						//$order = $dom->save("/var/www/camav/upload/order.xml");
						
						
						// END OF CREATION OF XML FILE
						
						
						echo "<tr>";
						echo "<td width=\"0%\"> <img src=\"fleche_ok.gif\" width=\"10\" height=\"8\"></td>";
						echo "<td width=\"0%\">&nbsp;</td>";
						echo "<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"33%\"><span class=\"title-small\" style=\"vertical-align: middle;\">Process Details</span></td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>	";
						echo "<tr>";
						echo "	<td width=\"0%\"></td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"99%\" colspan=\"3\">";
						echo "	<table border=\"0\" width=\"100%\" id=\"table2\">";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">Uploaded:</span></td>";
						echo "			<td><span class=\"text-normal\">".$strfile_is_uploaded."</font></span></td>";
						echo "			<td>&nbsp;</td>";
						echo "		</tr>";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">Processed:</span></td>";
						echo "			<td><div id=\"processinggif\"><span class=\"text-normal\">".$strProcessingStatus."</span></div></td>";
						echo "			<td>&nbsp;</td>";
						echo "		</tr>";
						echo "	</table>";
						echo "	</td>		";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";
						echo "<tr>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";
						echo "<tr>";
						echo "	<td width=\"0%\"> <img src=\"fleche_ok.gif\" width=\"10\" height=\"8\"></td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"33%\"><span class=\"title-small\" style=\"vertical-align: middle;\">File Details</span></td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";
						echo "<tr>";
						echo "	<td width=\"0%\"></td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"99%\" colspan=\"3\">";
						echo "	<table border=\"0\" width=\"100%\" id=\"table3\">";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">File Name:</span></td>";
						echo "			<td><span class=\"text-normal\">".$_FILES['file']['name']."</span></td>";
						echo "			<td><span class=\"text-normal\"><div id=\"queue\">Items in the queue before the file:</div></span></td>";
						echo "		</tr>";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">File Size:</span></td>";
						echo "			<td><span class=\"text-normal\">".$_FILES["file"]["size"]." bytes</span></td>";
						echo "			<td><span class=\"text-normal\"><div id=\"waiting\">Approximate waiting time:</div></span></td>";
						echo "		</tr>";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">Md5:</span></td>";
						echo "			<td><span class=\"text-normal\">".$strMD5."</span></td>";
						echo "			<td><span class=\"text-normal\"><div id=\"elapsed\">Elapsed time:</div></span></td>";
						echo "		</tr>";
						echo "		<tr>";
						echo "			<td width=\"10%\"><span class=\"text-normal\">Sha-1:</span></td>";
						echo "			<td><span class=\"text-normal\">".$strSHA1."</span> </td>";
						echo "			<td>&nbsp;</td>";
						echo "		</tr>";
						echo "	</table>";
						echo "	</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";
						echo "<tr>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";
						echo "<tr>";
						echo "	<td width=\"0%\"> <img src=\"fleche_ok.gif\" width=\"10\" height=\"8\"></td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"33%\"><span class=\"title-small\" style=\"vertical-align: middle;\">Results</span></td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>		";
						echo "<tr>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"0%\">&nbsp;</td>";
						echo "	<td width=\"99%\" colspan=\"3\"><div id=\"AVResult\">";
						
						//Java script function (Jquert ajax)
						echo "<script language=\"javascript\" type=\"text/javascript\">";
						//echo "setTimeout(\"checkFile('".$strMD5.",".$intActiveTask_av_Id."')\",2000);//va apela checkFile in 2 secunde";
						$vartest=$strMD5."&i=".$intActiveTask_av_Id;
						echo "setTimeout(\"checkFile('".$vartest."')\",2000);//va apela checkFile in 2 secunde";
						//setTimeout("checkFile('44d88612fea8a8f36de82e1278abb02f')",2000);
						//echo "setTimeout(function(){checkFile(".$strMD5.",".$intActiveTask_av_Id.")},20000)";
						echo "</script>";
						//END OF Java script function (Jquert ajax)						
						echo "												</div></td>		";
						echo "	<td width=\"33%\">&nbsp;</td>";
						echo "</tr>";						
						
					
						//#########HERE SHOULD COME THE REAL PROCESSING ...AND THRE RESULT. IF THE FILE WAS NOT MOVED THAT ERROR MESSAGE SHOULD BE SHOWN
						
						// sistemul de coada este implementat cu urmatoarea logica. beanstalkd server asculta pe portul 11300 incomming connections
						// apache-ul salveaza fisierul uploadat in /var/www/camav/upload cu numele md5-ul+anul luna ziua ora minutul secunda
						// fisierului uploadat (deci formatul va fisierului va fi md5_2011071111500 astazi fiind 1 Iulie 2011 ora 11 si 15 minute 00 secunde
						// folosesc acest format de fisier ca sa evit doua fisiere similare uploadate in acelasi timp cu acelasi md5
						
						// ulterior daemonul .... python sau sh sau un script lansat din cron va interoga beanstalkd pe portul 11300 
						//sa verifice daca este ceva in coada iara daca gaseste ceva acolo va procesa adica va lansa scriptul upanddown.sh .
						// Daca coada este goala atunci nu face nimic.
						
						//##########################################################################################
					
					}
					else
					{
						$intSomeError=1;
						$booFilemoved=0;
						echo "file NOT moved";
						//############# HERE ERROR MESSAGE IN CASE THE THE FILE HAS NOT BEEN MOVED
					}							
					//PANA AICI >>>AICI SE TERMINA INSERAREA

				} //end of else if ($_FILES["file"]["error"] > 0) Means if ($_FILES["file"]["error"] == 0)
			}
		  else //if file size is bigger than 4 mb
		  {
				$intSomeError=1;
				$strfile_is_uploaded="ERR: NOT UPLOADED";
				$strProcessingStatus="File Size Exccedded " .$_FILES["file"]["size"]." Max 4Mb"; 
				//echo "error";

		  }
		} 	//end of else of if the file was not updated ...meaning the file was updated
	}
	else //else of if ($intUploadBtnPushed==1)
	{
	 //the button was not set therefore we show nothing
	}
}  //end of else of Postsize .... if ($_SERVER['CONTENT_LENGTH'] > $mul*(int)$POST_MAX_SIZE && $POST_MAX_SIZE)
if ($intSomeError==1)  //some error is 0 default. Is some error have appeared this code will be show
	{
			echo "<tr>";
			echo "<td width=\"0%\"> <img src=\"fleche_ok.gif\" width=\"10\" height=\"8\"></td>";
			echo "<td width=\"0%\">&nbsp;</td>";
			echo "<td width=\"0%\">&nbsp;</td>";
			echo "	<td width=\"33%\"><span class=\"title-small\" style=\"vertical-align: middle;\">Process Details</span></td>";
			echo "	<td width=\"33%\">&nbsp;</td>";
			echo "	<td width=\"33%\">&nbsp;</td>";
			echo "	<td width=\"33%\">&nbsp;</td>";
			echo "</tr>	";
			echo "<tr>";
			echo "	<td width=\"0%\"></td>";
			echo "	<td width=\"0%\">&nbsp;</td>";
			echo "	<td width=\"0%\">&nbsp;</td>";
			echo "	<td width=\"99%\" colspan=\"3\">";
			echo "	<table border=\"0\" width=\"100%\" id=\"table2\">";
			echo "		<tr>";
			echo "			<td width=\"10%\"><span class=\"text-normal\">Uploaded:</span></td>";
			echo "			<td><span class=\"text-normal\">".$strfile_is_uploaded."</font></span></td>";
			echo "			<td>&nbsp;</td>";
			echo "		</tr>";
			echo "		<tr>";
			echo "			<td width=\"10%\"><span class=\"text-normal\">Processed:</span></td>";
			echo "			<td><div id=\"processinggif\"><span class=\"text-normal\">".$strProcessingStatus."</span></div></td>";
			echo "			<td>&nbsp;</td>";
			echo "		</tr>";
			echo "	</table>";
			echo "	</td>		";
			echo "	<td width=\"33%\">&nbsp;</td>";
			echo "</tr>";
	}
?>


</table>
</div>

          </td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
	</td>
  </tr>
    <tr><td>
      
	</td></tr>
</table>

          </td>
        </tr>
        <tr><td height="10"></td></tr>
      </table>
	</td>
  </tr>
    <tr><td>
      
	</td></tr>
</table>

        </td>
      </tr>
      <tr>
        <td>
<table width="94%" cellpadding="0" cellspacing="0" align="center">
  <tr><td colspan="2" height="10"></td></tr>
  <tr><td colspan="2" class="group-line level_2 text-smallest" align="left">
	Camav version 1.0 beta (CAMAV)&nbsp;
											                                
										<span class="color-table-red-text">
											&lt;&lt;&lt; Camav is unavailable daily from 2AM to 3 AM  &gt;&gt;&gt;
										</span>
  </td></tr>
  <tr><td colspan="2" height="10"></td></tr>
  <tr>
    <td width="50%" align="left">
      <table cellpadding="0" cellspacing="0">
        <tr>
          <td align="center">
            <a href="#top">
              <img src="top.gif" alt="Go to the top of this page" width="16" height="7" border="0">
            </a>
          </td>
        </tr>
        <tr>
          <td align="center">
            <a href="#top" class="top">
              top
            </a>
          </td>
        </tr>
      </table>
    </td>
    <td width="50%" align="right">
      <table cellpadding="0" cellspacing="0">
        <tr>
          <td align="center">
            <a href="#top">
              <img src="top.gif" alt="Go to the top of this page" width="16" height="7" border="0">
            </a>
          </td>
        </tr>
        <tr>
          <td align="center">
            <a href="#top" class="top">
              top
            </a>
          </td>
        </tr>
      </table>
    </td>
    <td></td>
  </tr>
  <tr>
    <td>
    </td>
  </tr>
  <tr><td colspan="2" height="10"></td></tr>
</table>

        </td>
      </tr>
    </table>
  </body>
</html>
