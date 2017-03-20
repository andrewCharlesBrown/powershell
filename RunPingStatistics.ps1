[System.Object[]] $test
[System.String] $targetMachine = "www.google.com"
[System.Int32] $countSucceeded = 0
[System.Int32] $countFailed = 0
[System.Int32] $sizeOfPacket = 32 #bytes
[System.Int32] $totalTime = 0
[System.Int32] $timeToConnect = 0
[System.Int32] $countTotalPackets = 0
[System.Double] $percentSucceeded = 0.0
[System.Double] $percentFailed = 0.0
[System.Double] $averageTime = 0.0
[System.Diagnostics.Stopwatch] $runtime = [System.Diagnostics.Stopwatch]::StartNew()
[System.Int32] $hours
[System.Int32] $minutes
[System.Int32] $seconds


while($true) {
    try {
        $test = Test-Connection -ComputerName $targetMachine -BufferSize $sizeOfPacket -Count 1 -ErrorAction Stop
        $timeToConnect = $test.ResponseTime
        $totalTime += $timeToConnect
        $countSucceeded++

    }
    catch {
        $countFailed++
    }

    $countTotalPackets++
    $averageTime = [System.Double]$totalTime / $countTotalPackets
    $percentSucceeded =  [System.Double]$countSucceeded / $countTotalPackets
    $hours = $runtime.Elapsed.Hours
    $minutes = $runtime.Elapsed.Minutes
    $seconds = $runtime.Elapsed.Seconds
  
  
  "{0:P0}" -f $percentSucceeded + " success with an average ping time of " + "{0:N4}" -f $averageTime + " ms at runtime point " + $hours + " hours, " + $minutes + " minutes, and " + $seconds + " seconds."

}

