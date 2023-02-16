$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Path to Chrome executable
$url1 = "https://prtg.bmd.at/map.htm?id=27028&tabid=1"  # First URL to navigate to
$url2 = "http://book-reports.bplaced.net/2022/index.html"  # Second URL to navigate to
$url3 = "http://book-reports.bplaced.net/2021/index.html"  # 3. URL to navigate to
$url4 = "http://book-reports.bplaced.net/2020/index.html"  # 4. URL to navigate to

$switchTime = 5 #Time Tab switch (Sek.)

Start-Process $chromePath -ArgumentList "--new-window",$url1,"--new-window",$url2,"--new-window",$url3,"--new-window",$url4

Start-Sleep 1  # Wait for Chrome to open and load the URLs

$wshell = New-Object -ComObject wscript.shell
$wshell.AppActivate("Google Chrome")  # Activate the Chrome window
$wshell.SendKeys("{F11}")  # Send the "F11" key to enter full screen mode

#$i = 0
while ($true) {
    Start-Sleep $switchTime  # Wait for $switchTime seconds
    $wshell.SendKeys("^{TAB}")  # Send the "Ctrl + Tab" key combination to toggle between tabs
    #$i += 1
    #if ($i -eq 10) {  # Stop after toggling between tabs 10 times
    #    break
    #}
}
