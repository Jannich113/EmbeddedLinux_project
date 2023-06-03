<?php

$File = 'sensor_log_file_1.csv';
$Handle = fopen($File, 'r');



$lines = array();
while (($line = fgetcsv($Handle)) !== false) {
    $lines[] = $line;
}

fclose($Handle);

$linesFromLast24 = array_slice($lines,-100);

$moisture_lines = array();
$light_lines = array();
$x_axis = array();


foreach ($linesFromLast24 as $line) {
    
    $temp_moisture = intval($line[2]);
    $temp_light = intval($line[3]);
    $temp_x = intval($line[4]);

    $moisture_lines[] = $temp_moisture;
    $light_lines[] = $temp_light;
    $x_axis[] = $temp_x;
}
?>

<!DOCTYPE html>
<html>
<a href="sensor_log_file_1.csv" download="sensor_log_file_1.csv">Download sensor log file</a>
    <button onclick="window.location.href = 'index.html';">Home</button>
<head>
    <title>Monitored sensor data</title>
    <script src="chart.js"></script>
</head>
<body>
    <canvas id="chart"></canvas>
    <script>
        
        var moisture_lines = <?php echo json_encode($moisture_lines); ?>;
        var light_lines = <?php echo json_encode($light_lines); ?>;
        var x_axis = <?php echo json_encode($x_axis); ?>;

        var ctx = document.getElementById('chart').getContext('2d');
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: x_axis,
                datasets: [
                    {
                        label: 'Soil Moisture',
                        data: moisture_lines,
                        backgroundColor: 'rgba(0, 123, 255, 0.5)',
                        borderColor: 'rgba(0, 123, 255, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Light',
                        data: light_lines,
                        backgroundColor: 'rgba(255, 193, 7, 0.5)',
                        borderColor: 'rgba(255, 193, 7, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Time'
                        }
                    },
                    y: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Value'
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
