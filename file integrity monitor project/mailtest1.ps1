Import-Module "C:\Users\lokesh\file integrity monitor project\mailmodule1.psm1"

Send-MailKitMessage -From 'lokeshchinnadurai727@outlook.com' -To 'lokeshchinnadurai727@outlook.com' -Subject"ALERT MESSAGE !  !  !" -Body "<h3>YOUR FILE HAS BEEN CHANGED</h3>" -BodyAsHtml -SMTPServer 'smtp-mail.outlook.com' -Port 587 -Credential $(Get-Credential)