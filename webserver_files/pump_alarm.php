<!DOCTYPE html>
<html>
  
<body>
    <center>
        <button onclick="window.location.href = 'index.html';">Home</button>
        <h1>Pump Alarms:</h1>
	<h3>Timestamp, PLANT_ID</h3>
        <?php
        $File = 'pump_alarm_file.csv';
        $Handle = fopen($File, 'r');

        while (($data = fgetcsv($Handle)) !== false) {
                echo implode(', ', $data) . "<br>";
        }

        fclose($Handle);
        ?>

<a href="pump_alarm_file.csv" download="pump_alarm_file.csv">Download pump alarm log</a> 
   <center>
<body>
<html>
