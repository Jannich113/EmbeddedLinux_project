<?php
    $csvFile = 'datalog.csv';
    $columnIndices = [0, 1, 2, 3]; // Replace with the desired column indices
    $names=["Plant alarm", "Pump alarm", "Soil moisture", "Light level"];
    // Read the CSV file into an array
    $rows = array_map('str_getcsv', file($csvFile));
    
    // Get the total number of rows in the CSV file
    $totalRows = count($rows);
    
    // Determine the starting index for the latest 10 entries
    $startIndex = max(0, $totalRows - 40);
    
    // Get the latest 10 entries with the specified values
    $latestEntries = array_slice($rows, $startIndex);
    
    // Transpose the entries from columns to rows
    $transposedEntries = array_map(null, ...$latestEntries);
    
    // Get the current timestamp
    $timestamp = date('Y-m-d H:i:s');


    // Log the transposed entries vertically with titles and timestamps
    foreach ($columnIndices as $index) {
        $title = $names[$index];
        echo "<h1 style='font-size: 20px; font-weight: bold;'>$title</h1>";
        $values = array_slice($transposedEntries[$index], 0, 10);
	$timestamps = array_slice($transposedEntries[4,0,10);      
        foreach ($values as $value) {
            echo $title . ': ' . $value . ' (' . $timestamps[ . ')<br>';
        }
      
        echo "<br>";
    }
    ?>

