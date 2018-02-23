@echo off
REM set /P var1=Enter path to RAM image file (in quotes):
set var1=%1
set var2="%USERPROFILE%\Desktop\Volatility.txt" 

REM Win7SP1x86, WinXPSP2x86, WinXPSP3x86, Win7SP1x64, Win2003SP2x64, Win2008R2SP01x64
REM set profile="--profile=Win7SP1x86"

set output="%USERPROFILE%\Desktop\volatility"
set csv="%USERPROFILE%\Desktop\volatility\mft.csv"

cd "%USERPROFILE%\Desktop\"
if not exist "%USERPROFILE%\Desktop\volatility" mkdir "%USERPROFILE%\Desktop\volatility"

echo running...
echo.
echo checking imageinfo

volatility-2.4.standalone.exe imageinfo -f %var1% %profile%
echo.
echo Enter profile with quotes. 
echo Example: "--profile=Win7SP1x64 other profile types are Win7SP1x86, WinXPSP2x86, WinXPSP3x86, Win7SP1x64, Win2003SP2x64, Win2008R2SP01x64"
set /P profile= 
echo.

echo psscan
@echo psscan  >> %var2%
@echo Scan Physical memory for _EPROCESS pool allocations >> %var2%
volatility-2.4.standalone.exe psscan -f %var1%  %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo pstree         
@echo psscan  >> %var2%
@echo pstree          Print process list as a tree >> %var2%
volatility-2.4.standalone.exe pstree -f %var1%  %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo running malfind
@echo malfind >> %var2%
if not exist "%USERPROFILE%\Desktop\volatility\malfind" mkdir "%USERPROFILE%\Desktop\volatility\malfind"
volatility-2.4.standalone.exe malfind -f %var1% "%profile%" -D "%USERPROFILE%\Desktop\volatility\malfind" >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%
echo.

echo running cmd history
@echo cmdscan [cmd history] >> %var2%
volatility-2.4.standalone.exe cmdscan -f %var1%  %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%
echo.

echo running printkey
@echo printkey [Run for ntuser.dat and SOFTWARE] >> %var2%
volatility-2.4.standalone.exe printkey -f %var1% %profile% -K "Microsoft\Windows\CurrentVersion\Run"
volatility-2.4.standalone.exe printkey -f %var1% %profile% -K "Microsoft\Windows\CurrentVersion\Run" >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%
echo printkey

@echo printkey [Winloggon]>> %var2%
volatility-2.4.standalone.exe printkey -f %var1% %profile% -K "Microsoft\Windows NT\CurrentVersion\Winlogon"
volatility-2.4.standalone.exe printkey -f %var1% %profile% -K "Microsoft\Windows NT\CurrentVersion\Winlogon" >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo bioskbd
@echo bioskbd Reads the keyboard buffer from Real Mode memory >> %var2%
volatility-2.4.standalone.exe bioskbd -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo dlldump
@echo dlldump Dump DLLs from a process address space >> %var2%
if not exist "%USERPROFILE%\Desktop\volatility\dlldump" mkdir "%USERPROFILE%\Desktop\volatility\dlldump"
volatility-2.4.standalone.exe dlldump -f %var1% %profile% -D "%USERPROFILE%\Desktop\volatility\dlldump"
@echo . >> %var2%
@echo ######### >> %var2%

echo procmemdump
@echo procmemdump Dump a process to an executable memory sample >> %var2%
if not exist "%USERPROFILE%\Desktop\volatility\EXEdump" mkdir "%USERPROFILE%\Desktop\volatility\EXEdump"
volatility-2.4.standalone.exe procdump -f %var1% %profile% -D "%USERPROFILE%\Desktop\volatility\EXEdump"
@echo . >> %var2%
@echo ######### >> %var2%

echo screenshot
@echo screenshot [Possible screenshots] >> %var2%
if not exist "%USERPROFILE%\Desktop\volatility\screenshot" mkdir "%USERPROFILE%\Desktop\volatility\screenshot"
volatility-2.4.standalone.exe screenshot -f %var1% %profile% -D "%USERPROFILE%\Desktop\volatility\screenshot" >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo userassist
@echo userassist Print userassist registry keys and information >> %var2%
volatility-2.4.standalone.exe userassist -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo sockscan
@echo sockscan  >> %var2%
volatility-2.4.standalone.exe sockscan -f %var1%  %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo connscan
@echo connscan  >> %var2%
@echo Scan Physical memory for _TCPT_OBJECT objects (tcp connections) >> %var2%
volatility-2.4.standalone.exe connscan -f %var1% %profile% >>%var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo netscan
@echo netscan  >> %var2%
@echo Scan Physical memory for _TCPT_OBJECT objects (tcp connections) >> %var2%
volatility-2.4.standalone.exe netscan -f %var1%  %profile% >>%var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo Sockets
@echo Sockets >> %var2%
volatility-2.4.standalone.exe sockets -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo connections
@echo connections - Print list of open connections [Windows XP and 2003 Only]>> %var2%
volatility-2.4.standalone.exe connections -f %var1% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo svcscan
@echo svcscan         Scan for Windows services >> %var2%
volatility-2.4.standalone.exe svcscan -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo filescan
@echo filescan [Scans for open files even if rootkit hidding] >> %var2%
volatility-2.4.standalone.exe filescan -f %var1%  %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo mftparser
@echo mftparser [Find mft data and create csv] >> %var2%
volatility-2.4.standalone.exe mftparser -f %var1% %profile% --output=body > %csv% 
@echo . >> %var2%
@echo ######### >> %var2%

echo ldrmodules
@echo ldrmodules Detect unlinked DLLs >> %var2%
volatility-2.4.standalone.exe ldrmodules -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo DllList
@echo DllList >> %var2%
volatility-2.4.standalone.exe dlllist -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo psxview
@echo psxview Find hidden processes with various process listings  0 = [pslist suspicious]>> %var2%
volatility-2.4.standalone.exe psxview -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo apihooks
@echo apihooks        Detect API hooks in process and kernel memory >> %var2%
volatility-2.4.standalone.exe apihooks -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo mutantscan
@echo mutantscan      Scan for mutant objects _KMUTANT >> %var2%
volatility-2.4.standalone.exe mutantscan -f %var1% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo idt
@echo idt             Display Interrupt Descriptor Table >> %var2%
volatility-2.4.standalone.exe idt -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%

echo handles
@echo handles [Open files and directories by EXE] >> %var2%
volatility-2.4.standalone.exe handles -f %var1% %profile% >> %var2%
@echo . >> %var2%
@echo ######### >> %var2%
