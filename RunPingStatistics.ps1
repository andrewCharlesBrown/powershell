function min([System.Double] $aTime) {
    if($aTime -lt $minTime) {
        $minTime = $aTime
    }
    return $minTime
}

function max([System.Double] $aTime) {
    if($aTime -gt $maxTime) {
        $maxTime = $aTime
    }
    return $maxTime
}

[System.Int32] $minTime = 1000
[System.Int32] $maxTime = 0
[System.Int32] $countSucceeded = 0
[System.Int32] $countFailed = 0
[System.Int32] $sizeOfPacket = 32 #bytes
[System.Int32] $countTotalPackets = 0
[System.Int32] $hours = 0
[System.Int32] $minutes = 0
[System.Int32] $seconds = 0
[System.Double] $totalTime = 0.0
[System.Double] $timeToConnect = 0.0
[System.Double] $percentSucceeded = 0.0
[System.Double] $percentFailed = 0.0
[System.Double] $averageTime = 0.0
[System.Object[]] $test
[System.String] $targetMachine = "www.bbc.com" # enter the machine you wish to ping
[System.Boolean] $failed = $false
[System.Diagnostics.Stopwatch] $runtime = [System.Diagnostics.Stopwatch]::StartNew()



while($true) {
    try {
        $test = Test-Connection -ComputerName $targetMachine -BufferSize $sizeOfPacket -Count 1 -ErrorAction Stop
        $failed = $false
        $countSucceeded++
        $timeToConnect = $test.ResponseTime
        $minTime = min($timeToConnect)
        $maxTime = max($timeToConnect)
        $totalTime += $timeToConnect
    }
    catch {
        $failed = $true
        $countFailed++
    }

    $countTotalPackets++
    $hours = $runtime.Elapsed.Hours
    $minutes = $runtime.Elapsed.Minutes
    $seconds = $runtime.Elapsed.Seconds

    if(!$failed) {
        $averageTime = $totalTime / $countSucceeded
        $percentSucceeded = [System.Double]$countSucceeded / $countTotalPackets
        
        "{0:P4}" -f $percentSucceeded + " success with an average ping time of " + "{0:N4}" -f $averageTime + `
        " ms at runtime point " + $hours + " hours, " + $minutes + " minutes, and " + $seconds + " seconds. The min time is " + $minTime + `
        ". The max time is " + $maxTime + ". " + $countFailed + " dropped packets."
       
    }
    elseif($failed) {
       Write-Host Connection failed at runtime point $hours hours, $minutes minutes, and $seconds seconds. -ForegroundColor Magenta -BackgroundColor Black
    }

    Start-Sleep -Seconds 1

}
