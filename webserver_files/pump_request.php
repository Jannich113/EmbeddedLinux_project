<!DOCTYPE html>
<html>
  
<body>
    <center>
        <button onclick="window.location.href = 'index.html';">Home</button>
        <h1>Pump activations:</h1>
        <h3>Timestamp, PLANT_ID</h3>
        <?php
        $File = 'pump_request_log.csv';
        $Handle = fopen($File, 'r');

        while (($data = fgetcsv($Handle)) !== false) {
                echo implode(', ', $data) . "<br>";
        }

        fclose($Handle);
        ?>

<a href="pump_request_log.csv" download="pump_request_log.csv">Download pump alarm log</a> 
   <center>
<body>
<html>
