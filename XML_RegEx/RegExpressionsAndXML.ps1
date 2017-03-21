# give the path to your xml file
$xmlFilePath = "Your file path"

# read the content of the xml file
[xml]$XmlDocument = Get-Content -Path $xmlFilePath

# get the number of nodes of the file
$nodeCount = $XmlDocument.dataroot.tblPhoneNumbers.Count

#loop through file, testing number format with regular expression 
for($i = 0; $i -lt $nodeCount; $i++) {

    # point to node indexed by counter $i
    $node = $XmlDocument.dataroot.tblPhoneNumbers[$i]
    
    # output formating errors to console 
    if($node.Phone_Numbers) {
        if(($node.Phone_Numbers -match  "\d{3}\.\d{3}\.\d{4}") -eq $False) {
            Write-Host "The number" $node.Phone_Numbers  "associated with" $node.First_Name $node.Last_Name "is in invalid format."
        }
    }

  
}
