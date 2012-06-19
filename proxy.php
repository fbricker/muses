<?php 
ini_set("user_agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)");
$f=fopen($_GET['url'],'r');
if(!$f) exit;
while(!feof($f)){
	echo fread($f,1024);
	flush();
}
fclose($f);