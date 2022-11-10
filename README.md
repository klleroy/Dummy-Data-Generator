# Dummy Data Generator Script

This Script will generate dummy data based upon contents of example CSVs.

## Usage

```PowerShell
# Change to your own directory
$dataSetDirectory = "fooBarDir"

# Change to your own directory
$exportDirectory = "dataExportDir"

# Exported File Name to save output
$exportNameCSV = "exportedData.csv"
$exportFilePath = Join-Path -Path $exportDirectory -ChildPath $exportNameCSV
```

## License

MIT
