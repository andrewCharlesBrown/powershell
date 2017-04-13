
$job = Start-Job -ScriptBlock {


$studentHereString = @'

using System;


public class Student
{
        
    private string name;
    private DateTime birthdate;
    private string major;
        
    public Student()
    {
        this.name = "Not Specified";
        this.birthdate = default(DateTime);
        this.major = "Not Specified";
    }

       
    public Student(string aName, int aYear, int aMonth, int aDay, string aMajor)
    {
        this.name = aName;
        this.birthdate = new DateTime(aYear, aMonth, aDay);
        this.major = aMajor;
    }

    public string getName() {
        return this.name;
    }

    public string getMajor() {
        return this.major;
    }

    public string getBirthdate() {
        return this.birthdate.ToShortDateString();
    }
   
    public void setName(string aName)
    {
        this.name = aName;
    }

    public void setMajor(string aMajor)
    {
        this.major = aMajor;
    }

    public void setBirthdate(int aYear, int aMonth, int aDay)
    {
        this.birthdate = new DateTime(aYear, aMonth, aDay);
    }
}

'@

Add-Type -TypeDefinition $StudentHereString

$std1 = New-Object -TypeName Student
$std2 = New-Object -TypeName Student("Robbie Robertson", 1943,7,5,"Music")

$std1.getName()
$std1.getBirthdate()
$std1.getMajor()
$std1.setName("Levon Helm")
$std1.setBirthdate(1940,5,26)
$std1.getName()
$std1.getBirthdate()
$std2.getMajor()
$std2.getName()
$std2.getBirthdate()

}

Wait-Job $job
Receive-Job $job
