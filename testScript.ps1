# define the number of days until password expiration
[System.int32] $numDaysWarning = 7


[System.Management.Automation.PSCredential] $cred = Get-Credential
[System.String] $from =  $from = $cred.UserName
[System.int32] $port = 587
[System.String] $smtpServer = "smtp.office365.com"
[System.String] $cc # define carbon copy email address here
[System.String] $reportEmail # define the address to which the general expiration reports will be sent to

# get object array of users and their password expiration data
[System.Object[]]$expiryData  = Get-ADUser -filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} -Properties "Displayname", "msDS-UserPasswordExprireyTimecomputed", "mail" |
Select-Object -Property "DisplayName", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExprireyTimecomputed")}},"mail"

[System.Text.StringBuilder] sbExpiring = New-Object System.Text.StringBuilder
[System.Text.StringBuilder] sbExpired = New-Object System.Text.StringBuilder

foreach ($user in $expiryData) {
    [System.String] $mail = $user.mail
    [System.String] $username = $user.DisplayName
    [System.DateTime] $dateExpires  = $user.ExpiryDate
    [System.DateTime] $todaysDate = Get-Date
    [System.TimeSpan] $timeToExpire = New-TimeSpan -Start $todaysDate -End $dateExpires
    [System.int32] $numDaysToExpire = $timeToExpire.Days
    [System.int32] $numHoursToExpire = $timeToExpire.Hours
    [System.int32] $numMinToExpire = $timeToExpire.Minutes
    [System.String] $messageStringExpiring = "The computer password for " + $username + " will expire in " + $numDaysToExpire + " days, " + 


}







