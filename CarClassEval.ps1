# original code URL: https://blogs.technet.microsoft.com/heyscriptingguy/2015/09/01/powershell-5-create-simple-class/#comments

Class Car {

    [System.String]$vin
    static [System.int16]$numberOfWheels = 4
    [System.int16]$numberOfDoors
    [System.DateTime]$year
    [String]$model

}

$chevy = New-Object car

$chevy::numberOfWheels 
# "I can use the Static property operator to view my static property:" Yes, you can, but referencing static members of a class does not require -
# that you first construct an object of that type.

[car]::numberOfWheels 
# Referencing a static variable directly from its class - this could be done without implementing line 10 above.

# Directly accessing these variables violates one of the fundamental OOP principles: encapsulation. 
$chevy.vin = 12345
$chevy.numberOfDoors = 2
$chevy.year = "5/1/2015"
$chevy.model = "Camero"

$chevy 