# Function to send an email with CC, BCC, and attachments

function Send-EmailWithAttachments {
    param(
        [string]$from,
        [string]$to,
        [string]$cc,
        [string]$bcc,
        [string]$subject,
        [string]$body,
        [string[]]$attachmentPaths,
        [string]$smtpServer,
        [int]$smtpPort,
        [string]$smtpUsername,
        [string]$smtpPassword
    )

    # Create a new SmtpClient
    $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtpClient.EnableSsl = $true
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)

    # Create a new MailMessage
    $mailMessage = New-Object System.Net.Mail.MailMessage($from, $to)
    
    # Add CC recipients if provided
    if ($cc) {
        $mailMessage.CC.Add($cc)
    }

    # Add BCC recipients if provided
    if ($bcc) {
        $mailMessage.Bcc.Add($bcc)
    }

    $mailMessage.Subject = $subject
    $mailMessage.Body = $body

    # Attach files if provided
    if ($attachmentPaths) {
        foreach ($attachmentPath in $attachmentPaths) {
            $attachment = New-Object System.Net.Mail.Attachment($attachmentPath)
            $mailMessage.Attachments.Add($attachment)
        }
    }

    # Send the email
    $smtpClient.Send($mailMessage)

    # Dispose the attachment objects
    foreach ($attachment in $mailMessage.Attachments) {
        $attachment.Dispose()
    }
}

# Usage example
$from = "lokeshchinnadurai727@outlook.com"
$to = "lokeshchinnadurai727@outlook.com"
$cc = "lokeshchinnadurai727@outlook.com"
$bcc = "lokeshchinnadurai727@outlook.com"
$subject = "ALERT MESSAGE  !  !  !"
$body = "YOUR FILE HAS BEEN CHANGED.."
$attachmentPaths = @("C:\Users\lokesh\file integrity monitor project\files\test2.txt","C:\Users\lokesh\file integrity monitor project\files\testpr1.txt")

$smtpServer = "smtp-mail.outlook.com"
$smtpPort = 587
$smtpUsername = "lokeshchinnadurai727@outlook.com"
$smtpPassword = "lokeshdurai@727"


Send-EmailWithAttachments -from $from -to $to -cc $cc -bcc $bcc -subject $subject -body $body -attachmentPaths $attachmentPaths `
    -smtpServer $smtpServer -smtpPort $smtpPort -smtpUsername $smtpUsername -smtpPassword $smtpPassword

