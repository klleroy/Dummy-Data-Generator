
# Dataset Directory | Change to your own directory
$datasetDirectory = "D:\PSScripts\DataSource"

$exportDirectory = "D:\PSScripts\DataExport"

# Female First Names 
$femaleFirstNamesCSV = "femaleNames.csv"
$femalesFilePath = Join-Path -Path $datasetDirectory -ChildPath $femaleFirstNamesCSV

# Male First Names 
$maleFirstNamesCSV = "maleNames.csv"
$malesFilePath = Join-Path -Path $datasetDirectory -ChildPath $maleFirstNamesCSV

# Surnames
$lastNamesCSV = "lastNames.csv"
$lastNamesFilePath = Join-Path -Path $datasetDirectory -ChildPath $lastNamesCSV

# Postcodes
$postalCodesCSV = "postalCodes.csv"
$postalCodesFilePath = Join-Path -Path $datasetDirectory -ChildPath $postalCodesCSV

# Street Names
$streetNamesCSV = "streetnames.csv"
$streetnamesFilePath = Join-Path -Path $datasetDirectory -ChildPath $streetNamesCSV

# Export Name, file to save output
# $exportNameCSV = "dummyData-10k.csv"
# $exportFilePath = Join-Path -Path $exportDirectory -ChildPath $exportNameCSV

# Export Name, file to save output
$exportNameCSV = "dummyData-100k.csv"
$exportFilePath = Join-Path -Path $exportDirectory -ChildPath $exportNameCSV

# Export Name, file to save output
# $exportNameCSV = "dummyData-1M.csv"
# $exportFilePath = Join-Path -Path $exportDirectory -ChildPath $exportNameCSV

# Female First Names
if ($femalesFilePath) {
  # Import the .csv file
  $femalesFirstNames = Import-Csv -Path $femalesFilePath | Select-Object -Property "First_Name"  | ForEach-Object {    
    $_."First_Name" = (Get-Culture).TextInfo.ToTitleCase($_."First_Name".ToLower())    
    $_
  }
}

# Male First Names
if ($malesFilePath) {
  # Import the .csv file
  $maleFirstNames = Import-Csv -Path $malesFilePath | Select-Object -Property "First_Name" | ForEach-Object {    
    $_."First_Name" = (Get-Culture).TextInfo.ToTitleCase($_."First_Name".ToLower())
    $_
  }
}  

# Combine Male and Female First Names
$firstNames = $femalesFirstNames + $maleFirstNames

# Last Names
if ($lastNamesFilePath) {
  $lastNames = Import-Csv -Path $lastNamesFilePath | Select-Object -Property "LastNames" | ForEach-Object {          
    $_.LastNames = (Get-Culture).TextInfo.ToTitleCase($_.LastNames.ToLower())
    $_    
  }
} 

# Postal Codes
if ($postalCodesFilePath) {
  $postalCodes = Import-Csv -Path $postalCodesFilePath | Select-Object -Property "zip", "city", "state_id" 
}

# Street Names List
if ($streetnamesFilePath) {   
  $streetNames = Import-Csv -Path $streetnamesFilePath | Select-Object -Property "street_name" | ForEach-Object {    
    $_."STREET_NAME" = (Get-Culture).TextInfo.ToTitleCase($_."STREET_NAME".ToLower())
    $_
  }
}

# Generate 100 random users and append to .csv file
1..100000 | ForEach-Object {
  # 1..100000 | ForEach-Object {
  # 1..1000000 | ForEach-Object {
  $randGivenName = $firstNames | Get-Random
  $randLastName = $lastNames | Get-Random
  $randPostalCode = $postalCodes | Get-Random
  $randStreet = $streetNames | Get-Random
  $randStreetNumber = (Get-Random -Minimum 1 -Maximum 10000)

  $body = [pscustomobject] [ordered] @{
    FirstName = $randGivenName."First_Name"
    LastName  = $randLastName.LastNames
    Street    = [string]$randStreetNumber + " " + $randStreet.STREET_NAME
    City      = $randPostalCode.city
    State     = $randPostalCode.state_id
    Postcode  = $randPostalCode.zip
    FilePath  = $datasetDirectory + "\" + $randLastName.LastNames + ".docx"
  }
  $body = $body | Export-Csv -Path $exportFilePath -Append
  $body
}