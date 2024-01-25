Import-Module "C:\Users\lokesh\file integrity monitor project\mailmodule.ps1"

#$creds=Get-Credential
#$creds | Export-Clixml -path "C:\Users\lokesh\file integrity monitor project\EmailCred.xml"

$EmailCredentialsPath="C:\Users\lokesh\file integrity monitor project\EmailCred.xml"
$EmailCredentials=Import-Clixml -path $EmailCredentialsPath
#$EmailCredentials=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUsername, (ConvertTo-SecureString -String $smtpPassword -AsPlainText -Force)
$EmailServer="smtp-mail.outlook.com"
$EmailPort="587"


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
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv" ){
            Write-Error -Message "$baselineFilePath need to be in .csv file" -ErrorAction Stop
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
        [Parameter(Mandatory)]$baselineFilePath,
        [Parameter()]$emailTo


    )
    try{
        if((Test-Path -path $baselineFilePath) -eq $false){
            Write-Error -Message "$baselineFilePath dose not exist" -ErrorAction Stop

        }
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv" ){
            Write-Error -Message "$baselineFilePath need to be in .csv file" -ErrorAction Stop
        }
        $baselineFiles=Import-Csv -Path $baselineFilePath -Delimiter ","

        foreach($file in $baselineFiles){ 
            if(Test-Path -Path $file.path){
                    $currenthash = Get-FileHash -Path $file.path 
                    if($currenthash.Hash -eq $file.Hash){
            
                        Write-Output "$($file.path) is still the same"

                    }else{
                        Write-Output "$($file.path) hash is different and something has changed"
                        if($emailTo){
                            Send-EmailWithAttachments -To $emailTo -From $EmailCredentials.UserName -Subject "ALERT MESSAGE  !  !  !" -Body "$($file.path) hash is different and something has changed" -SMTPServer $EmailServer -Port $EmailPort -Credential $EmailCredentials

                        }
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
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv" ){
            Write-Error -Message "$baselineFilePath need to be in .csv file" -ErrorAction Stop
        }
        "path,hash" | Out-File -FilePath $baselineFilePath -Force
    }catch{
        return $_.Exception.Message
    }
}

Write-Output "File monitor system V1"
do{
    Write-Output "Enter the following options or enter the q or quit to quit "
    Write-Output "1. set the baseline file; current set baseline $($baselineFilePath)"
    Write-Output "2.add the path to baseline"
    Write-Output "3.check files against baseline"
    Write-Output "4.create a new baseline"
    $entry=Read-Host -Prompt "please enter the selection"
    
    switch ($entry) {
          "1"{
            $baselineFilePath=Read-Host -Prompt "Enter the baseline file path"
            if(Test-Path -Path $baselineFilePath){
                if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv" ){

                }else{
                    $baselineFilePath=""
                    Write-Output " invalid file need to be in .csv file"
                }
            }else{
                $baselineFilePath=""
                Write-Output " invalid file path for baseline"
            }
        }
          "2"{
            $targerFilePath= Read-Host -Prompt "Enter the file that you want to monitor "
            Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath $targerFilePath
            
          }
          "3" {
            Verify-Baseline -baselineFilePath $baselineFilePath
          }
          "4"{ 
            $newBaselineFilePath=Read-Host -Prompt "enter the new baseline file path"
            Create-Baseline -baselineFilePath $newBaselineFilePath
          }
          "q"{}
          "quit"{}
        Default {
            Write-Output "-------------invalid entry------------"
        }
    }



}while($entry -notin @('q','quit'))


 
$baselineFilePath=""
#Create-Baseline -baselineFilePath $baselineFilePath

#Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath "C:\Users\lokesh\file integrity monitor project\files\testpr1.txt"
#Verify-Baseline -baselineFilePath $baselineFilePath -emailTo  "lokeshdurai727@outlook.com"


