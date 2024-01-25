# Install the required packages if not already installed
Install-Package MimeKit
Install-Package MailKit

# Import the necessary namespaces
#using namespace MimeKit
#using namespace MailKit.Net.Smtp

# Sender and recipient email addresses
$from = "sender@example.com"
$to = "recipient@example.com"

# SMTP server configuration
$smtpServer = "smtp-mail.outlook.com"
$smtpPort = 587
$smtpUsername = "your_username"
$smtpPassword = "your_password"

# Email subject and body
$subject = "File Integrity Monitor Report"
$body = "This is the email body."

# Create a new MimeMessage
$message = New-Object MimeMessage
$message.From.Add([MailboxAddress]::Parse($from))
$message.To.Add([MailboxAddress]::Parse($to))
$message.Subject = $subject
$message.Body = [TextPart]::Text($body)

# Create a new SmtpClient
$smtpClient = New-Object SmtpClient

# Configure the SmtpClient
$smtpClient.Connect($smtpServer, $smtpPort, $false)
$smtpClient.Authenticate($smtpUsername, $smtpPassword)

# Send the email
$smtpClient.Send($message)

# Disconnect from the SMTP server
$smtpClient.Disconnect($true)
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.4.1.0\lib\netstandard2.1\MimeKit.dll"
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MailKit.4.1.0\lib\netstandard2.1\MailKit.dll"
