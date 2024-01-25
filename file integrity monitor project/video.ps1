function Add-FileToBaseline{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$baselineFilePath,
        [Parameter(Mandatory)]$targetFilePath
    )
    try{
        if((Test-Path -path $baselineFilePath) -eq $false){
            Write-Error -Message "$baselineFilePath dose not exist" -ErrorAction Stop

        }
        if((Test-Path -path $targetFilePath) -eq $false){
            Write-Error -Message "$targetFilePath dose not exist" -ErrorAction Stop
        }
        $hash=Get-FileHash -Path $targetFilePath
        "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append
        Write-Output "----------------------entry successfully added into the baseline-------------------------------------"

    }catch{
        return $_.Exception.Message
    }

}

function Verify-Baseline{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$baselineFilePath

    )
    try{
        if((Test-Path -path $baselineFilePath) -eq $false){
            Write-Error -Message "$baselineFilePath dose not exist" -ErrorAction Stop

        }
        $baselineFiles=Import-Csv -Path $baselineFilePath -Delimiter ","

        foreach($file in $baselineFiles){ 
            if(Test-Path -Path $file.path){
                    $currenthash = Get-FileHash -Path $file.path 
                    if($currenthash.Hash -eq $file.Hash){
            
                        Write-Output "$($file.path) is still the same"

                    }else{
                        Write-Output "$($file.path) hash is different and something has changed"
                    }
    
            }else{
                    Write-Output "$($file.Path) is not found!"
                }
            
                 
        }


    }catch{
        return $_.Exception.Message

    }

}
function Create-Baseline{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory)]$baselineFilePath

    )
    try{
        if((Test-Path -path $baselineFilePath)){
            Write-Error -Message "$baselineFilePath Already exist the file with this name" -ErrorAction Stop
        } 
        "path,hash" | Out-File -FilePath $baselineFilePath -Force
    }catch{
        return $_.Exception.Message
    }
}




$baselineFilePath="C:\Users\lokesh\file integrity monitor project\baseline.csv"
Create-Baseline -baselineFilePath $baselineFilePath

Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath "C:\Users\lokesh\file integrity monitor project\files\test2.txt"
Verify-Baseline -baselineFilePath $baselineFilePath 


