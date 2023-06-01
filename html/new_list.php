<?php
// Read the CSV file
$csvFile = 'sensor_log_file_1.csv';
$fileHandle = fopen($csvFile, 'r');

// Check if the file could be opened
if ($fileHandle === false) {
    die("Failed to open the CSV file.");
}

// Read the file and store the lines in an array
$lines = array();
while (($line = fgetcsv($fileHandle)) !== false) {
    $lines[] = $line;
}

// Close the file handle
fclose($fileHandle);

// Extract the last 10 lines
$last10Lines = array_slice($lines,-86400);

// Initialize arrays to store the data
$moistureData = array();
$lightData = array();
$xLabels = array();

// Process the last 10 lines of the CSV file
foreach ($last10Lines as $line) {
    // Extract the relevant values from each line
    $moisture = intval($line[2]);
    $light = intval($line[3]);
    $xLabel = intval($line[4]); // Extract the last 8 characters as the X label

    // Add the data to the arrays
    $moistureData[] = $moisture;
    $lightData[] = $light;
    $xLabels[] = $xLabel;
}
?>
