
function getFileStamp($fileName)
{
    $name = $fileName -Replace '\{\"VEX\.'
    $name = $name -Replace '\xlsx\"'
    
    return $name
    }
    
function Main()
{
    Write-Host "logging in to web site"
    $r = invoke-webrequest https://someurl.com -SessionVariable foo
    $r.Forms[0].fields["user"] = "spaz"
    $r.Forms[0].fields["password"] = 'FR0AT'
    $result = Invoke-webrequest https://someurl.com -WebSession $foo -Body $r -Method Post
    if($rewult.StatusCode -ne "200")
    {
        Write-Host "failed to login"
        exit
    }
    
    $toMEUrl = "https://someurl.com/ToME/"
    $fileList = Invoke-webrequest https://someurl.com/ToMe/?T -WebSession $foo -Method Get
    
    if($fileList.StatusCode -ne "200")
    {
        Write-Host "failed to get a list of files"
        exit
    }
    
    $vexFileNameRegex = [regex] '\(\"VEX\.[0-9]+\.xlsx\"'
    $results = $vixFileNameRegex.Matches($fileList.Content)
    
    write-host $results.count
    foreach($fileName in $results)
    {
        $timeStamp = getFileStamp $fileName
        $vroUri = $toMeUrl + "VRO.$timeStamp.csv?B"
        $vraUri = $toMeUrl + "VRA.$timeStamp.csv?B"
        $vexUri = $toMeUrl + "VEX.$timeStamp.xlsx?B"
        $delvroUri = $toMeUrl + "VRO.$timeStamp.csv?D"
        $delvraUri = $toMeUrl + "VRA.$timeStamp.csv?D"
        $delvEXUri = $toMeUrl + "VEX.$timeStamp.xlsx?D"
        
        $vroFile= ".\VRO.$timeStamp.csv"
        $vraFile= ".\VRA.$timeStamp.csv"
        $vexFile= ".VEX.$timeStamp.xlsx"
        
        Invoke-webrequest -Uri $vroUri -OutFile $vroFile -WebSession $foo
        Invoke-webrequest -Uri $vraUri -OutFile $vraFile -WebSession $foo
        Invoke-webrequest -Uri $vexUri -OutFile $vexFile -WebSession $foo
        Unblock-File $vroFile
        Unblock-File $vraFile
        Unblock-File $vexFile
        
        #Invoke-webrequest -Uri $delvroUri -WebSession $lpl
        #Invoke-webrequest -Uri $delvraUri -WebSession $lpl
        #Invoke-webrequest -Uri $delvexUri -WebSession $lpl
    }
}
    
Main