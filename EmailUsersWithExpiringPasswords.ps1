
<#
.SYNOPSIS

This script emails users with passwords that are about to expire, or have recently expired.
By: Andrew Brown
www.zinmorrow.com
Sunday, March 12, 2017 1:21:54 PM

#>

# Ad Module should import automatically with Get-ADUser but if not...
Import-Module ActiveDirectory

# define the number of days until password expiration
[int32] $numDaysWarning = 7

# define arguments for Send-MailMessage
[System.Management.Automation.PSCredential]$cred = get-credential
[System.String] $from = $cred.UserName
[int32] $port # your defined smtp port
[System.String] $smtpServer # your defined smtp server
[System.String] $cc # define carbon copy - good for verifying emails are being sent appropriately 
[System.String] $reportEmail # define the address to which the password expiry final reports will be sent

# get object array of users and their password expiration data from ADUC
[System.Object[]] $expiryData = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties “DisplayName”, “msDS-UserPasswordExpiryTimeComputed”, "mail" |
Select-Object -Property “Displayname”,@{Name=“ExpiryDate”;Expression={[datetime]::FromFileTime($_.“msDS-UserPasswordExpiryTimeComputed”)}},"mail" | Sort-Object DisplayName

# define StringBuilder objects to collect report data
[System.Text.StringBuilder] $sbExpiring = New-Object System.Text.StringBuilder
[System.Text.StringBuilder] $sbExpired = New-Object System.Text.StringBuilder


# loop through object array $expiryData, setting values for the subject and body of the email to be sent to users
foreach($user in $expiryData) {

    [System.String] $mail = $user.mail
    [System.String] $username = $user.Displayname
    [System.DateTime] $dateExpires = $user.ExpiryDate
    [System.DateTime] $todaysDate = Get-Date
    [System.TimeSpan] $daysToExpire = New-TimeSpan -Start $todaysDate -End $dateExpires
    [int32] $numDaysToExpire = $daysToExpire.Days
    [int32] $numHoursToExpire = $daysToExpire.Hours
    [int32] $numMinToExpire = $daysToExpire.Minutes
    [System.String] $subjectStringExpiring = "The computer password for " + $username + " will expire in " + $numDaysToExpire + " days, " + $numHoursToExpire + " hours, and " + $numMinToExpire + " minutes."
    [System.String] $subjectStringExpired = "The computer password for " + $username + " has expired."
    [System.String] $messageBodyExpiring = "The computer password associated with the user login " + $username + " will be expiring on " + $dateExpires  + "."
    [System.String] $messageBodyExpired = "The computer password associated with the user login " + $username + ", has expired."
    [System.String] $subjectStringExpiringReport = "Passwords expiring within the next 7 days: report."
    [System.String] $subjectStringExpiredReport = "Passwords expired within the last 3 days: report."


    # if an email address is not null for a user in ADUC, and their password is expiring within the next 7 days or has expired within the last 3 days -
    # send an email alert detailing that expiry information
    if($mail) {

    
       if(($numDaysToExpire -le $numDaysWarning) -and ($numDaysToExpire -ge 0 -and $numHoursToExpire -ge 0 -and $numMinToExpire -gt 0)) {
            $sbExpiring.Append($username + " on " + $dateExpires + "::")
            Send-MailMessage -To $mail -from $from -Subject $subjectStringExpiring -Body $messageBodyExpiring -BodyAsHtml -Cc $cc -smtpserver $smtpServer -usessl -Credential $cred -Port $port
        }
        elseif(($numDaysToExpire -lt 0 -or $numHoursToExpire -lt 0 -or $numMinToExpire -lt 0) -and ($numDaysToExpire -ge -3)) {
            $sbExpired.Append($username + " on " + $dateExpires + "::")
            Send-MailMessage -To $mail -from $from -Subject $subjectStringExpired -Body $messageBodyExpired -BodyAsHtml -Cc $cc -smtpserver $smtpServer -usessl -Credential $cred -Port $port
        }

    }

   
}

 # email a report of all expired and expiring user passwords to sysadmin or helpdesk
 Send-MailMessage -To $reportEmail -from $from -Subject $subjectStringExpiringReport -Body $sbExpiring.ToString() -BodyAsHtml -smtpserver $smtpServer -usessl -Credential $cred -Port $port
 Send-MailMessage -To $reportEmail -from $from -Subject $subjectStringExpiredReport -Body $sbExpired.ToString() -BodyAsHtml -smtpserver $smtpServer -usessl -Credential $cred -Port $port







