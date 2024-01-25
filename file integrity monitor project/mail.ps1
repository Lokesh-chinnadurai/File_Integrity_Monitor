Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.4.1.0\lib\netstandard2.0\MimeKit.dll"

Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MailKit.4.1.0\lib\netstandard2.0\MailKit.dll"


#Add-Type -AssemblyName System.Configuration
#$smtpSection = [System.Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp')
$SMTP=New-Object MailKit.Net.Smtp.SmtpClient
$Message=New-Object MimeKit.MimeMessage
$Builder=New-Object MimeKit.BodyBuilder
$SMTP = New-Object System.Net.Mail.SmtpClient
$Account=Import-Clixml -Path C:\Users\lokesh\file_integrity_monitor_project\outlook.xml
#Get-Credential | Export-Clixml -Path C:\Users\lokesh\file_integrity_monitor_project\outlook.xml
#$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Account.UserName,$Account.Password
$SMTP.Credentials = New-Object System.Net.NetworkCredential($username, $password)
$Message.From.Add("lokeshchinnadurai727@outlook.com")
$Message.To.Add("lokeshchinnadurai727@outlook.com")
$Message.Subject="ALERT MESSAGE!!!"
$Builder.TextBody= "THIS IS THE TEST MAIL MESSAGE"
$Message.Body=$builder.ToMessageBody()


$SMTP.Timeout = 10  # Set timeout to 10 seconds (adjust as needed)
$SMTP.EnableSsl =$smtpSection.Network.EnableSsl
$SMTP.Connect('smtp-mail.outlook.com' ,465 ,$false)
$SMTP.Authenticate($Account)
$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.dispose()




