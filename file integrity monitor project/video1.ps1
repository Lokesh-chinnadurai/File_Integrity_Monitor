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
        $currentBaseline= Import-Csv -Path $baselineFilePath -Delimiter ","
        if($targetFilePath -in $currentBaseline.path){
            Write-Output "File path directed already in baseline file"
            do{
                $overwrite=Read-Host -Prompt "Path exist already in baseline file, would you like to overwrite it {Y/N}}:"
                
                if($overwrite -in @('y','yes')){
                    Write-Output "File path will be overwritten"
                    $currentBaseline | where-object path -ne $targetFilePath | Export-Csv -Path $baselineFilePath -Delimiter "," -NoTypeInformation
                    $hash=Get-FileHash -Path $targetFilePath
                    "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append
                    Write-Output "----------------------entry successfully added into the baseline-------------------------------------"

                    

                }elseif($overwrite -in @('n','no')){
                    Write-Output "File path will not be overwritten "

                }else{
                    Write-Output "Invalid entry,pls enter the y to overwrite or n  not to overwrite the file"
                }
            }while($overwrite -notin 'y','yes','n','no')
        
        }else{
            $hash=Get-FileHash -Path $targetFilePath
            "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append
            Write-Output "----------------------entry successfully added into the baseline-------------------------------------"

        }
        $currentBaseline= Import-Csv -Path $baselineFilePath -Delimiter ","
        $currentBaseline | Export-Csv -Path $baselineFilePath -Delimiter "," -NoTypeInformation


        

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



 
$baselineFilePath="C:\Users\lokesh\file integrity monitor project\baseline01.csv"
#Create-Baseline -baselineFilePath $baselineFilePath

Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath "C:\Users\lokesh\file integrity monitor project\files\testpr1.txt"
#Verify-Baseline -baselineFilePath $baselineFilePath 


