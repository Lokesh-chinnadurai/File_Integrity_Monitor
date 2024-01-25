$smtpServer = "smtp-mail.outlook.com"  
$smtpPort = 587  
$smtpUsername = "lokeshdurai"  
$smtpPassword = "lokeshdurai@727"  
$senderEmail = "lokeshchinnadurai727@outlook.com"  
$recipientEmail = "lokeshchinnadurai727@outlook.com"
$filePath = "C:\Users\lokesh\file integrity monitor project\files\testpr1.txt"  
$initialHash = Get-FileHash -Path $filePath -Algorithm SHA256 | Select-Object -ExpandProperty Hash
    while ($true) {
    
        $currentHash = Get-FileHash -Path $filePath -Algorithm SHA256 | Select-Object -ExpandProperty Hash


        if ($currentHash -ne $initialHash) {

            $subject = "File Integrity Alert: $filePath has been modified"
            $body = "The file $filePath has been modified."

            Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -UseSsl 
                -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUsername, (ConvertTo-SecureString -String $smtpPassword -AsPlainText -Force)) 
                -From $senderEmail -To $recipientEmail -Subject $subject -Body $body

            break
        }

    
        Start-Sleep -Seconds 1
    }
