#Simple Clock

Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object 'System.Windows.Forms.Form'
$Form.Text = "Clock"
$Form.BackColor = "#000000"
$Form.TopMost = $True
$Form.Width = 210
$Form.Height = 90
$Form.MaximizeBox = $False
$Form.FormBorderStyle = 'Fixed3D'

$clockLbl = New-Object 'System.Windows.Forms.Label'
$clockLbl.Text = (Get-Date).ToString("HH:mm:ss")
$clockLbl.AutoSize = $True
$clockLbl.ForeColor = "Orange"
$clockLbl.Location = New-Object System.Drawing.Point(0,0)
$clockLbl.Font = "DS-Digital,32,style=Bold"
$Form.Controls.Add($clockLbl)

$timer1 = New-Object 'System.Windows.Forms.Timer'
$timer1_Tick={
    $clockLbl.Text = (Get-Date).ToString("HH:mm:ss")
}

$timer1.Enabled = $True
$timer1.Interval = 1
$timer1.add_Tick($timer1_Tick)

[void]$Form.ShowDialog()
$Form.Dispose()