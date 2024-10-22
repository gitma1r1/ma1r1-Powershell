
 #Grafischer Ping mit Powershell like GPing
 
 # Import necessary assemblies for the form, drawing, and charts
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

# Global variable for the ping interval
$global:pingInterval = 100 # ms
$global:host_tick_1 = 0

# Create a new form and set properties
$form = New-Object System.Windows.Forms.Form
$form.Text = "Ping Tool"
$form.Width = 700 # Breiteres Fenster
$form.Height = 830
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"

# Function to validate IP address
function ValidateIP {
    param ([string]$ip)
    $octet = '(?:0?0?[0-9]|0?[1-9][0-9]|1[0-9]{2}|2[0-5][0-5]|2[0-4][0-9])' # matches 0-255
    $ipv4Regex = "^(?:$octet\.){3}$octet$" # match an actual IP address
    return $ip -match $ipv4Regex
}

# Create labels, text boxes, and buttons with improved layout
$controls = @(
    @{ Text = "BMDCloud:"; Location = @{ X = 10; Y = 10 }; TextBox = "1.1.1.1" },
    @{ Text = "Google:"; Location = @{ X = 10; Y = 50 }; TextBox = "8.8.8.8" },
    @{ Text = "Ping Interval (ms):"; Location = @{ X = 10; Y = 90 }; TextBox = "100" }
    )

foreach ($control in $controls) {
    # Create label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $control.Text
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point($control.Location.X, $control.Location.Y)
    $form.Controls.Add($label)

    # Create textbox
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Width = 100
    $textBox.Text = $control.TextBox
    $textBox.Location = New-Object System.Drawing.Point(160, $control.Location.Y)
    $form.Controls.Add($textBox)

    # Add select all on Ctrl + A
    $textBox.Add_KeyUp({
        if ($_.Control -and $_.KeyCode -eq 'A') {
            $textBox.SelectAll()
        }
    })
}

# Create start/stop button and add click event
$startStopButton = New-Object System.Windows.Forms.Button
$startStopButton.Text = "Start"
$startStopButton.Width = 75
$startStopButton.Location = New-Object System.Drawing.Point(330,10)
$startStopButton.Add_Click({
    if ($startStopButton.Text -eq "Start") {
        # Get the hostnames from the text boxes
        $hostname1 = $form.Controls[1].Text
        $hostname2 = $form.Controls[3].Text

        if ($hostname1 -eq $hostname2){
            [System.Windows.Forms.MessageBox]::Show("Hosts sind identisch...")
            return
        }
        
        if (-not (ValidateIP $hostname1) -or -not (ValidateIP $hostname2)) {
            [System.Windows.Forms.MessageBox]::Show("Falsches IP-Format. Bitte geben Sie eine gültige IPv4-Adresse ein.")
            return
        }

        # Get and validate the ping interval from the textbox
        $newInterval = [int]$form.Controls[5].Text
        if ($newInterval -lt 1) {
            [System.Windows.Forms.MessageBox]::Show("Ping interval muss positiv sein.")
            return
        }
        
        $global:pingInterval = $newInterval
        $pingTimer.Interval = $global:pingInterval  # Update timer interval

        # Display start time in the label
        $startTimeLabel.Text = "Startzeit: $(Get-Date -Format 'HH:mm:ss')"

        $startStopButton.Text = "Stop"
        $pingTimer.Start()
    } else {
        $startStopButton.Text = "Start"
        $pingTimer.Stop()
    }
})
$form.Controls.Add($startStopButton)

# Create reset button and add click event
$resetButton = New-Object System.Windows.Forms.Button
$resetButton.Text = "Reset"
$resetButton.Width = 75
$resetButton.Location = New-Object System.Drawing.Point(330,50)
$resetButton.Add_Click({
    $chart1.Series[0].Points.Clear()
    $chart2.Series[0].Points.Clear()
    $global:host_tick_1 = 0
    $pingCounterLabel.Text = "Rounds: $global:host_tick_1"
    $resultLabel1.Text = ""
    $resultLabel2.Text = ""
    $startTimeLabel.Text = ""
})
$form.Controls.Add($resetButton)

# Create labels to display response time and start time
$resultLabel1 = New-Object System.Windows.Forms.Label
$resultLabel1.AutoSize = $true
$resultLabel1.Location = New-Object System.Drawing.Point(420, 10)
$form.Controls.Add($resultLabel1)

$resultLabel2 = New-Object System.Windows.Forms.Label
$resultLabel2.AutoSize = $true
$resultLabel2.Location = New-Object System.Drawing.Point(420, 40)
$form.Controls.Add($resultLabel2)

$startTimeLabel = New-Object System.Windows.Forms.Label
$startTimeLabel.AutoSize = $true
$startTimeLabel.Location = New-Object System.Drawing.Point(420, 70)
$form.Controls.Add($startTimeLabel)

# Create label to display global ping counter
$pingCounterLabel = New-Object System.Windows.Forms.Label
$pingCounterLabel.Text = "Rounds: $global:host_tick_1"
$pingCounterLabel.AutoSize = $true
$pingCounterLabel.Location = New-Object System.Drawing.Point(420, 100) 
$form.Controls.Add($pingCounterLabel)

# Create a timer and add tick event
$pingTimer = New-Object System.Windows.Forms.Timer
$pingTimer.Interval = $global:pingInterval
$pingTimer.Add_Tick({
    $global:host_tick_1 += 1
    $pingCounterLabel.Text = "Rounds: $global:host_tick_1"

    # Send ping to first host and display response time
    try {
        $result1 = Test-Connection -ComputerName $form.Controls[1].Text -Count 1 -ErrorAction SilentlyContinue
        $resultLabel1.Text = "BMDCloud: " + $result1.ResponseTime + " ms"
        $chart1.Series[0].Points.AddXY($global:host_tick_1, $result1.ResponseTime)

    } catch {
        $resultLabel1.Text = "BMDCloud: nicht erreichbar!"
        $chart1.Series[0].Points.AddXY($global:host_tick_1, 0)
    }

    # Send ping to second host and display response time
    try {
        $result2 = Test-Connection -ComputerName $form.Controls[3].Text -Count 1 -ErrorAction SilentlyContinue
        $resultLabel2.Text = "Google: " + $result2.ResponseTime + " ms"
        $chart2.Series[0].Points.AddXY($global:host_tick_1, $result2.ResponseTime)

    } catch {
        $resultLabel2.Text = "Google: nicht erreichbar!"
        $chart2.Series[0].Points.AddXY($global:host_tick_1, 0)
    }

    # Update chart settings
    foreach ($chart in @($chart1, $chart2)) {
        $chart.ChartAreas[0].AxisX.ScaleView.Size = 100

        # Dynamically adjust Y-axis
        if ($chart.Series[0].Points.Count -gt 0) {
            $maxY = ($chart.Series[0].Points | ForEach-Object { $_.YValues[0] } | Measure-Object -Maximum).Maximum
            $minY = [Math]::Max(0, $maxY - 50) # Ensure a minimum value of 0
            $chart.ChartAreas[0].AxisY.Minimum = $minY
            $chart.ChartAreas[0].AxisY.Maximum = $maxY + 50 # Add some padding
        }

        if ($chart.Series[0].Points.Count -gt 100) {
            $chart.ChartAreas[0].AxisX.ScaleView.Position = $chart.Series[0].Points.Count - 100
        }
    }
})

# Create chart for first host
$chart1 = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart1.Location = New-Object System.Drawing.Point(10, 140) # Verschoben nach oben
$chart1.Size = New-Object System.Drawing.Size(620, 300) # Breiter
$chartArea1 = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chartArea1.AxisX.Title = "Ping Rounds"
$chartArea1.AxisY.Title = "Ping Time (ms)"
$chart1.ChartAreas.Add($chartArea1)
$series1 = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$series1.Name = "Ping1"
$series1.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$series1.Color = [System.Drawing.Color]::Blue # Farbe der Linie für den ersten Host
$chart1.Series.Add($series1)
$form.Controls.Add($chart1)

# Create chart for second host
$chart2 = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart2.Location = New-Object System.Drawing.Point(10, 460) # Verschoben nach oben
$chart2.Size = New-Object System.Drawing.Size(620, 300) # Breiter
$chartArea2 = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chartArea2.AxisX.Title = "Ping Rounds"
$chartArea2.AxisY.Title = "Ping Time (ms)"
$chart2.ChartAreas.Add($chartArea2)
$series2 = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$series2.Name = "Ping2"
$series2.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$series2.Color = [System.Drawing.Color]::Red # Farbe der Linie für den zweiten Host
$chart2.Series.Add($series2)
$form.Controls.Add($chart2)

# Show the form
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
