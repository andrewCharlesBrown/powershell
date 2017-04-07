# So now lets look at the article given here: https://blogs.technet.microsoft.com/heyscriptingguy/2015/08/31/introduction-to-powershell-5-classes/ 
# and write some script based on a different approach. We will extend our original class Car to a child class Coupe, rather than implement static methods.
# We will also use some getter and setter (or accesor and mutator) methods, in addition to a defined class constructor, to manipulate our object's member fields.

class Car {

    [System.String]$vin
    [System.Byte]$numberOfWheels
    [System.Byte]$numberOfDoors
    [System.DateTime]$year
    [String]$model

    # Car constructor
    Car ([System.String]$aVin, [System.Byte]$ANumberOfDoors, [System.DateTime]$aYear, [String]$aModel) {
        $this.vin = $aVin
        $this.numberOfWheels = 4
        $this.numberOfDoors = $ANumberOfDoors
        $this.year = $aYear
        $this.model = $aModel
    }

    [System.String] getVin() {
        return $this.vin
    }

    [System.Byte] getNumberOfWheels() {
        return $this.numberOfWheels
    }

    [System.Byte] getNumberOfDoors() {
        return $this.numberOfDoors
    }

    [System.DateTime] getYear() {
        return $this.year
    }

    [System.String] getModel() {
        return $this.model
    }

}

$chevy = New-Object car("abc123", 4, "5/1/2015", "X")

$chevy.getVin()
$chevy.getNumberOfWheels()
$chevy.getNumberOfDoors()
$chevy.getYear()
$chevy.getModel()
