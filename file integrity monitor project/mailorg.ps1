# Sender and recipient email addresses
$from = "lokeshchinnadurai727@outlook.com"
$to = "lokeshchinnadurai727@outlook.com"

# SMTP server configuration
$smtpServer = "smtp-mail.outlook.com"
$smtpPort = 587
$smtpUsername = "lokeshchinnadurai727@outlook.com"
$smtpPassword = "lokeshdurai@727"

# Email subject and body
$subject = "ALERT MESSAGE !  !  !"
$body = "YOUR FILE HAS BEEN CHANGED."

# Create a new SMTP client
$smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtpClient.EnableSsl = $true
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)

# Create a new MailMessage object
$mailMessage = New-Object System.Net.Mail.MailMessage($from, $to, $subject, $body)

# Send the email
$smtpClient.Send($mailMessage)
