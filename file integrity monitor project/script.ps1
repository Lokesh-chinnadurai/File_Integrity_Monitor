$baselineFilePath="C:\Users\lokesh\file integrity monitor project\baseline.csv"
$fileToMonitorPath="C:\Users\lokesh\file integrity monitor project\files\testpr1.txt"
$hash=Get-FileHash -Path $fileToMonitorPath
"$($fileToMonitorPath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append

$baselineFiles=Import-Csv -Path $baselineFilePath -Delimiter ","

foreach($file in $baselineFiles){ 
    if ($null -ne $files.path -and $files.path -ne ''){
    
    if(Test-Path -Path $file.path){
        $currenthash = Get-FileHash -Path $file.path 
        if($currenthash.Hash -eq $file.Hash){
            
            Write-Output "$($file.path) is still the same"

        }else{
            Write-Output "$($file.path) hash is different and something has changed"
        }
    
    }else {
        Write-Output "$($file.Path) is not found!"
    }
  
    }
}