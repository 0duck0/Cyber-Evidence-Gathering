?clear-host
Get-Content C:\windows\temp\computers.txt | % {
  $ComputerName = $_

  $paths = "\\$ComputerName\C$\ProgramData\GoogleChrome\chrome_frame_helper.dll.hlp",
           "\\$ComputerName\C$\ProgramData\Chrome\chrome_frame_helper.dll.rom",
           "\\$ComputerName\C$\ProgramData\Chrome\NvSmart.hlp",
           "\\$ComputerName\C$\ProgramData\Vne\nsf.dat",
           "\\$ComputerName\C$\ProgramData\GoogleChrome\Adb.hlp",
           "\\$ComputerName\C$\ProgramData\Chrome\chrome_frame_helper.dll",
           "\\$ComputerName\C$\ProgramData\Chrome\chrome_frame_helper.exe",
           "\\$ComputerName\C$\ProgramData\GoogleChrome\chrome_frame_helper.dll"

  $dst = "\\c:\windows\temp\hashesfound.txt"
  
    foreach($path in $paths) {
        Write-Host "checking $ComputerName for IOC"
        Get-hash $path -ErrorAction SilentlyContinue -Outvariable:output 
        Out-File -FilePath C:\windows\temp\hashesfound.txt -InputObject $output -Append
}
}
