$OU = "Distinguished Name of OU"
$deptName = "Name Of Department"

$users = Get-ADUser -Filter * -SearchBase $OU -Properties department

Foreach ($user in $users) {
	
	if($user.department -ne $deptName) {
	
		try {
			Set-ADUser -Identity $user -Replace @{department = ($deptName)} -ErrorAction Stop
			Write-Host Success for:  $user.name -foregroundcolor "green"
		}
		catch {
			Write-Host Failure for: $user.name -foregroundcolor "red"
		}
	}
	else  {
		Write-Host Department name for $user.name already correctly designated. -foregroundcolor "magenta"
	}
			
		
}

