<!DOCTYPE html>
<html>
<head>
    <title>CSV Data Visualization</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div style="display: flex;">
        <div style="flex: 1;">
            <?php
            // Path to the CSV file
            $csvFile = 'datalog.csv';

            // Columns indices to extract values from (starting from 0)
            $columnIndices = [0, 1, 2]; // Replace with the desired column indices

            // Names for each column
            $names = ["Plant alarm", "Pump alarm", "Soil moisture", "Light level"];

            // Read the CSV file into an array
            $rows = array_map('str_getcsv', file($csvFile));

            // Transpose the entries from columns to rows
            $transposedEntries = array_map(null, ...$rows);

            // Get the current timestamp
            $timestamp = date('Y-m-d H:i:s');

            // Display the first 10 entries of each column with the corresponding name and timestamp
            foreach ($columnIndices as $index) {
                $title = $names[$index];
                echo "<h1 style='font-size: 20px; font-weight: bold;'>$title</h1>";
                $values = array_slice($transposedEntries[$index], 0, 10);

                foreach ($values as $value) {
                    echo $value . ' (' . $timestamp . ')<br>';
                }

                echo "<br>";
            }
            ?>
        </div>

        <div style="flex: 1;">
            <?php
            // Get the latest 50 entries of a specific column for the first chart
            $chartColumnIndex1 = 3; // Replace with the desired column index for the first chart
            $chartEntries1 = array_slice(array_column($rows, $chartColumnIndex1), -$totalRows, 50);

            // Format the chart entries as JSON for the first chart data
            $chartData1 = json_encode($chartEntries1);

            // Get the latest 50 entries of a specific column for the second chart
            $chartColumnIndex2 = 4; // Replace with the desired column index for the second chart
            $chartEntries2 = array_slice(array_column($rows, $chartColumnIndex2), -$totalRows, 50);

            // Format the chart entries as JSON for the second chart data
            $chartData2 = json_encode($chartEntries2);
            ?>

            <canvas id="chart1" style="width: 100%; height: -50%;"></canvas>
            <canvas id="chart2" style="width: 100%; height: 5%;"></canvas>

            <script>
                // Retrieve the first chart data from PHP
                var chartData1 = <?php echo $chartData1; ?>;
                
                // Create the first chart with the retrieved data
                var ctx1 = document.getElementById('chart1').getContext('2d');
                new Chart(ctx1, {
                    type: 'line',
                    data: {
                        labels: Array.from({length: chartData1.length}, (_, i) => i + 1),
                        datasets: [{
                            label: 'Column Data',
                            data: chartData1,
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Entry Index'
                                }
                            },
                            y: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Column Value'
                                },
                                suggestedMin: 0,
                                suggestedMax: 100
                            }
                        }
                    }
                });

                // Retrieve the second chart data from PHP
                var chartData2 = <?php echo $chartData2; ?>;
                
                // Create the second chart with the retrieved data
                var ctx2 = document.getElementById('chart2').getContext('2d');
                new Chart(ctx2, {
                    type: 'line',
                    data: {
                        labels: Array.from({length: chartData2.length}, (_, i) => i + 1),
                        datasets: [{
                            label: 'Column Data',
                            data: chartData2,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgba(255, 99, 132, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Entry Index'
                                }
                            },
                            y: {
                                display: true,
                                title: {
                                    display: true,
                                    text: 'Column Value'
                                },
                                suggestedMin: 0,
                                suggestedMax: 100
                            }
                        }
                    }
                });
            </script>
        </div>
    </div>
</body>
</html>
