<?php
if(isset($_GET["aktion"])) {
	switch ($_GET["aktion"]) {
		case stop:
			exec("service aufzeichnung stop",$ausgabe,$fehler);
			print_r($ausgabe);
			if($fehler == 1) { echo "ein Fehler ist aufgetreten";}
			break;
		case start:
			exec("service aufzeichnung start",$ausgabe,$fehler);
			print_r($ausgabe);
			if($fehler == 1) { echo "ein Fehler ist aufgetreten";}
			break;
		case running:
			$lauft=shell_exec( "ls /home/pi/ |grep aufzeichnung.lock" );
			if($lauft == "") { 
				echo "<script type='text/javascript'>alert('Achtung!\\nDie Aufzeichnung ist gestoppt');</script>";
			}
			break;
		case gnuplot:
			$datei = fopen("/var/www/gnuplot_erstellen","w");
			echo fwrite($datei, "Hallo Welt",100);
			fclose($datei);
	}
} else {
	echo "Parameter wird benötigt";
 $datei = fopen("/var/www/gnuplot_erstellen","w");
                        echo fwrite($datei, "Hallo Welt",100);
                        fclose($datei);

}
//exec("sudo service aufzeichnung stop",$ausgabe,$fehler);
//exec("gnuplot /home/pi/Temperaturmessung/Einstellungen.plt");
//header("Location: http://10.0.0.22/gnuplot.html");
?>
