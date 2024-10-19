#JosephusAnswer
function Get-JosephusAnswer{
[Parameter(mandatory=$true,HelpMessage="Enter the number of peopele",
 ValueFromPipeline=$true)]

param([int]$value)

$number = [Convert]::ToString($value,2) #Step1: Convert the initial value to Binary
$i=$number[0] #$step2:store the most significant digit
$number = $number.Remove(0,1)#Step3:remove the most significant digit from the orginal number
$number = $number.Insert($number.Length,$i)#Step4: insert the binary digit from Step2 to the least significant index
$position = [Convert]::ToInt32($number,2)#step5: convert the binary back to an integer and right out to the user.
Write-host "Josephus Problem: $value Leute | Person $position überlebt " -ForegroundColor Green
}

function Set-JosephusNumber ($n) {
$i = 2
    while ($i -le $n){
    Get-JosephusAnswer -value $i
    $i ++
      }
}
Set-JosephusNumber -n 100 #Input 100 
#test