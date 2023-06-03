<!DOCTYPE html>
<html>
  
<body>
    <center>
        <button onclick="window.location.href = 'index.html';">Home</button>
        <h1>Plant Alarms:</h1>
	<h3>Timestamp, PLANT_ID</h3>
        <?php
        $File = 'plant_alarm_file.csv';
        $Handle = fopen($File, 'r');

        while (($data = fgetcsv($Handle)) !== false) {
                echo implode(', ', $data) . "<br>";
        }

        fclose($Handle);
        ?>

<a href="plant_alarm_file.csv" download="plant_alarm_file.csv">Download plant alarm log</a> 
   <center>
<body>
<html>
