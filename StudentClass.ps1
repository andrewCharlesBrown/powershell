$studentHereString = @'

using System;

public class Student
    {
        
        private string name;
        private DateTime birthdate;

        
        public Student()
        {
            this.name = "Not Specified";
            this.birthdate = default(DateTime);
        }

       
        public Student(string aName, int aYear, int aMonth, int aDay)
        {
            this.name = aName;
            this.birthdate = new DateTime(aYear, aMonth, aDay);
        }

        public string getName() {
            return this.name;
        }

        public DateTime getBirthdate() {
            return this.birthdate;
        }
   
        public void setName(string aName)
        {
            this.name = aName;
        }

        public void setBirthdate(int aYear, int aMonth, int aDay)
        {
            this.birthdate = new DateTime(aYear, aMonth, aDay);
        }
    }

'@

Add-Type -TypeDefinition $StudentHereString

$std1 = New-Object -TypeName Student
$std2 = New-Object -TypeName Student("Robbie Robertson", 1943,7,5)

$std1.getName()
$std1.getBirthdate()
$std1.setName("Levon Helm")
$std1.setBirthdate(1940,5,26)
$std1.getName()
$std1.getBirthdate()

$std2.getName()
$std2.getBirthdate()