#--------------------------------------------------------------------------------------------------
#Test Dauer 1:
$duration1 = Measure-Command {
    #Code to test her
    Test-Connection www.github.com -Count 1 -ErrorAction SilentlyContinue
}
#Print Result Test1
Write-Host "Test1: "$duration1.TotalSeconds # Ausgabe der Dauer von Test1 


#--------------------------------------------------------------------------------------------------
#Test Dauer 2:
$duration2 = Measure-Command {
    #Code to test her
    Test-Connection www.github.com -Count 1 -BufferSize 16KB -ErrorAction SilentlyContinue
}
#Print Result Test2
Write-Host "Test2: "$duration2.TotalSeconds # Ausgabe der Dauer von Test2


#--------------------------------------------------------------------------------------------------
#Test Dauer 3:
$duration3 = Measure-Command {
    #Code to test her
    ping -n 1 -l 1 www.github.com
}
#Print Result Test3
Write-Host "Test3: "$duration3.TotalSeconds # Ausgabe der Dauer von Test3


