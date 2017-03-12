# WARNING - NOT YET DEBUGGED

<#
.SYNOPSIS

This script emails users with passwords that are about to expire, or have recently expired.
By: Andrew Brown
www.zinmorrow.com
Sunday, March 12, 2017 1:21:54 PM

#>


Import-Module ActiveDirectory

# define the number of days until password expiration
[System.int32] $numDaysWarning = 7

# define arguments for Send-MailMessage
[System.Management.Automation.PSCredential] $cred = Get-Credential
[System.String] $from =  $from = $cred.UserName
[System.int32] $port = 587 # or your defined port
[System.String] $smtpServer = "smtp.office365.com" # or your defined smtp server
[System.String] $cc # define carbon copy email address here
[System.String] $reportEmail # define the address to which the general expiration reports will be sent to

# get object array of users and their password expiration data from ADUC
[System.Object[]]$expiryData  = Get-ADUser -filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} -Properties "Displayname", "msDS-UserPasswordExprireyTimecomputed", "mail" |
Select-Object -Property "DisplayName", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExprireyTimecomputed")}},"mail" | Sort-Object "DisplayName"

# define StringBuilder objects to collect report data
[System.Text.StringBuilder] $sbExpiring = New-Object System.Text.StringBuilder
[System.Text.StringBuilder] $sbExpired = New-Object System.Text.StringBuilder

# loop through object array $expiryData, setting values for the subject and body of the email to be sent to users
foreach ($user in $expiryData) {
    [System.String] $mail = $user.mail
    [System.String] $username = $user.DisplayName
    [System.DateTime] $dateExpires  = $user.ExpiryDate
    [System.DateTime] $todaysDate = Get-Date
    [System.TimeSpan] $timeToExpire = New-TimeSpan -Start $todaysDate -End $dateExpires
    [System.int32] $numDaysToExpire = $timeToExpire.Days
    [System.int32] $numHoursToExpire = $timeToExpire.Hours
    [System.int32] $numMinToExpire = $timeToExpire.Minutes
    [System.String] $subjectStringExpiring = "The computer password for " + $username + " will expire in " + $numDaysToExpire + " days, " + $numHoursToExpire + " hours, and " + $numMinToExpire + " minutes."
    [System.String] $subjectStringExpired = "The computer password for " + $username + " has expired."
    [System.String] $bodyStringExpiring = "The computer password associated with the user login " + $username + " will be expiring on " + $dateExpires + "."
    [System.String] $bodyStringExpired = "The computer password associated with the user login " + $username + " has expired."
    [System.String] $subjectStringExpiringReport = "Passwords expiring within the next 7 days: report."
    [System.String] $subjectStringExpiredReport = "Passwords expired within the last 3 days: report."

    
    # if an email address is not null for a user in ADUC, and their password is expiring within the next 7 days or has expired within the last 3 days -
    # send an email alert detailing that expiry information
    if($mail) {

        if(($numDaysToExpire -le $numDaysWarning) -and ($numDaysToExpire -ge 0 -and $numHoursToExpire -ge 0 -and $numMinToExpire -gt 0)) {
            $sbExpiring.Append($username + " on " + $dateExpires + "::")
            Send-MailMessage -To $mail -From $from -Subject $subjectStringExpiring -Body $bodyStringExpiring -BodyAsHtml -Cc $cc -SmtpServer $smtpServer -UseSsl -Credential $cred -Port $port
        }
        elseif(($numDaysToExpire -lt 0 -or $numHoursToExpire -lt 0 -or $numMinToExpire -lt 0) -and ($numDaysToExpire -ge -3)) {
            $sbExpired.Append($username + " on " + $dateExpires + "::")
            Send-MailMessage -To $mail -From $from -Subject $subjectStringExpired -Body $bodyStringExpired -BodyAsHtml -Cc $cc -SmtpServer $smtpServer -UseSsl -Credential $cred -Port $port
        }

    }


    # email a report of all expired and expiring user passwords to sysadmin or helpdesk
    Send-MailMessage -To $reportEmail -From $from -Subject $subjectStringExpiringReport -Body $sbExpiring -BodyAsHtml -Cc $cc -SmtpServer $smtpServer -UseSsl -Credential $cred -Port $port
    Send-MailMessage -To $reportEmail -From $from -Subject $subjectStringExpiredReport -Body $sbExpiring -BodyAsHtml -Cc $cc -SmtpServer $smtpServer -UseSsl -Credential $cred -Port $port
}







