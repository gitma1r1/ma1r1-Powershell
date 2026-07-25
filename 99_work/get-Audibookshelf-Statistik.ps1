# ===================================================
# AUDIOBOOKSHELF - STATISTIK & HISTORIE (EXTENDED)
# ===================================================

$headers = @{ "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXlJZCI6ImVjMWUyM2U0LTkwNGUtNDY1NS1hMzVkLWFjOThiZTRiZDY3MCIsIm5hbWUiOiJ0ZXN0IiwidHlwZSI6ImFwaSIsImlhdCI6MTc4NDYzMzc3M30.2t0rlug-QRPyFhSQFq0oPGvkxUkjelU9nMNEestlbcI" }
$baseUrl = "http://ma1r1.duckdns.org:13378"

$libraries = @(
    @{ Id = "34d5d2ff-9610-42fa-921c-8fcac6959250"; Name = "Heard" },
    @{ Id = "4dddbc49-d7c9-46e9-8b61-0f26669bcffe"; Name = "Not Heard" }
)

function Format-Duration ([double]$seconds) {
    $ts = [TimeSpan]::FromSeconds($seconds)
    $days = [math]::Floor($ts.TotalDays)
    return "{0}d {1}h {2}m" -f $days, $ts.Hours, $ts.Minutes
}

$libData = @()
$heardBooks = @()

Write-Host "`n[+] Lade Hörbücher aus Audiobookshelf..." -ForegroundColor DarkGray

foreach ($lib in $libraries) {
    $uri = "$baseUrl/api/libraries/$($lib.Id)/items?limit=0"
    $response = Invoke-RestMethod -Uri $uri -Headers $headers

    $libSeconds = 0
    $libCount = $response.results.Count

    foreach ($item in $response.results) {
        $duration = 0
        if ($item.media.audioFiles) {
            $duration = ($item.media.audioFiles | Measure-Object -Property duration -Sum).Sum
        } elseif ($item.media.duration) {
            $duration = [double]$item.media.duration
        }

        $title = $item.media.metadata.title
        $author = $item.media.metadata.authorName

        if ($duration -gt 0) {
            $libSeconds += $duration
            
            if ($lib.Name -eq "Heard") {
                $heardBooks += [PSCustomObject]@{
                    Title    = if ($author) { "$author - $title" } else { $title }
                    Author   = if ($author) { $author } else { "Unbekannter Autor" }
                    Duration = $duration
                }
            }
        }
    }

    $avgSec = if ($libCount -gt 0) { $libSeconds / $libCount } else { 0 }

    $libData += [PSCustomObject]@{
        Id       = $lib.Id
        Name     = $lib.Name
        Count    = $libCount
        TotalSec = $libSeconds
        AvgSec   = $avgSec
    }
}

$heardLib = $libData | Where-Object { $_.Name -eq "Heard" }
$notHeardLib = $libData | Where-Object { $_.Name -eq "Not Heard" }

# Extremwerte (Heard)
$heardShortest = $heardBooks | Sort-Object Duration | Select-Object -First 1
$heardLongest  = $heardBooks | Sort-Object Duration -Descending | Select-Object -First 1

# Top 5 Autoren (Heard)
$topAuthors = $heardBooks | Group-Object Author | Select-Object @{N='Autor';E={$_.Name}}, @{N='Bücher';E={$_.Count}}, @{N='Stunden';E={[math]::Round(($_.Group | Measure-Object -Property Duration -Sum).Sum / 3600, 1)}} | Sort-Object Bücher, Stunden -Descending | Select-Object -First 5

# Berechnungen Leistung
$startDate = Get-Date -Year 2020 -Month 1 -Day 1
$daysSince2020 = (New-TimeSpan -Start $startDate -End (Get-Date)).Days
$yearsSince2020 = [math]::Round($daysSince2020 / 365.25, 2)

$heardHours = $heardLib.TotalSec / 3600
$heardDays  = $heardLib.TotalSec / 86400

$avgHoursPerDay  = $heardHours / $daysSince2020
$avgMinPerDay    = [math]::Round($avgHoursPerDay * 60, 0)
$avgHoursPerYear = [math]::Round($heardHours / $yearsSince2020, 0)
$avgBooksPerYear = [math]::Round($heardLib.Count / $yearsSince2020, 1)

# Meilenstein-Prognosen
$targetHours = 2000  # Nächstes Stundenziel
if ($heardHours -gt 2000) { $targetHours = [math]::Ceiling($heardHours / 1000) * 1000 }
$remainingHours = $targetHours - $heardHours
$daysToTarget = if ($avgHoursPerDay -gt 0) { [math]::Round($remainingHours / $avgHoursPerDay) } else { 0 }
$targetDate = (Get-Date).AddDays($daysToTarget).ToString("dd.MM.yyyy")

# Offener Vorrat (Ungehört)
$notHeardDays = [math]::Round($notHeardLib.TotalSec / 86400, 1)
$daysToFinishQueue = if ($avgHoursPerDay -gt 0) { [math]::Round(($notHeardLib.TotalSec / 3600) / $avgHoursPerDay) } else { 0 }

# ===================================================
# OPTISCHE AUSGABE
# ===================================================

Clear-Host

Write-Host "==========================================================================" -ForegroundColor DarkCyan
Write-Host "                   AUDIOBOOKSHELF - ANALYTICS & PROGNOSEN                 " -ForegroundColor Cyan
Write-Host "==========================================================================" -ForegroundColor DarkCyan

# 1. BIBLIOTHEKEN ÜBERSICHT
Write-Host "`n  BIBLIOTHEKEN IM VERGLEICH" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------------------------" -ForegroundColor DarkGray

$tableOutput = foreach ($lib in $libData) {
    [PSCustomObject]@{
        "Bibliothek"   = $lib.Name
        "Titel"        = $lib.Count
        "Gesamtdauer"  = Format-Duration $lib.TotalSec
        "Stunden"      = [math]::Round($lib.TotalSec / 3600, 0)
        "Ø pro Buch"   = Format-Duration $lib.AvgSec
    }
}
$tableOutput | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host "   $_" -ForegroundColor White }


# 2. SEIT 2020 GEHÖRT (ANALYSE)
Write-Host "  HÖR-LEISTUNG SEIT 2020 ($yearsSince2020 JAHRE / $daysSince2020 TAGE)" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "   • Absolvierte Bücher : " -NoNewline; Write-Host "$($heardLib.Count) Hörbücher" -ForegroundColor Green
Write-Host "   • Gesamte Hörzeit    : " -NoNewline; Write-Host "$(Format-Duration $heardLib.TotalSec) " -NoNewline -ForegroundColor Green; Write-Host "($([math]::Round($heardHours, 0)) Std. / $([math]::Round($heardDays, 1)) voller 24h-Tage)" -ForegroundColor Gray
Write-Host "   • Ø Hörzeit pro Tag  : " -NoNewline; Write-Host "$avgMinPerDay Minuten/Tag " -ForegroundColor Cyan -NoNewline; Write-Host "($([math]::Round($avgHoursPerDay, 2)) Std./Tag)" -ForegroundColor Gray
Write-Host "   • Ø Tempo pro Jahr   : " -NoNewline; Write-Host "~$avgBooksPerYear Bücher/Jahr " -ForegroundColor Cyan -NoNewline; Write-Host "($avgHoursPerYear Std./Jahr)" -ForegroundColor Gray
Write-Host "   • Äquivalent         : " -NoNewline; Write-Host "$([math]::Round($heardHours / 8, 0)) Arbeitstage (à 8 Std.)" -ForegroundColor DarkYellow
Write-Host ""


# 3. PROGNOSE & SUB-STATISTIK (NEU!)
Write-Host "  PROGNOSE & UNGEHÖRTER VORRAT" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "   • Ziel-Meilenstein   : " -NoNewline; Write-Host "$targetHours Std. Hörzeit" -ForegroundColor White -NoNewline; Write-Host " (noch $([math]::Round($remainingHours,0))h / voraussichtlich am " -NoNewline -ForegroundColor Gray; Write-Host "$targetDate" -ForegroundColor Green -NoNewline; Write-Host ")" -ForegroundColor Gray
Write-Host "   • Ungehörter Vorrat  : " -NoNewline; Write-Host "$($notHeardLib.Count) Bücher" -ForegroundColor White -NoNewline; Write-Host " ($([math]::Round($notHeardLib.TotalSec / 3600, 0)) Std. / $notHeardDays Tage am Stück)" -ForegroundColor Gray
Write-Host "   • Reichweite Vorrat  : " -NoNewline; Write-Host "Reicht bei aktuellem Tempo für ca. " -NoNewline -ForegroundColor Gray; Write-Host "$daysToFinishQueue Tage " -ForegroundColor Cyan -NoNewline; Write-Host "($([math]::Round($daysToFinishQueue / 30, 1)) Monate)" -ForegroundColor Gray
Write-Host ""


# 4. EXTREMWERTE (NUR HEARD)
Write-Host "  EXTREMWERTE (NUR GEHÖRTE BÜCHER)" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "   Kürzestes Buch : " -NoNewline; Write-Host "$($heardShortest.Title)" -ForegroundColor White -NoNewline; Write-Host " ($(Format-Duration $heardShortest.Duration))" -ForegroundColor Gray
Write-Host "   Längstes Buch  : " -NoNewline; Write-Host "$($heardLongest.Title)" -ForegroundColor White -NoNewline; Write-Host " ($(Format-Duration $heardLongest.Duration))" -ForegroundColor Gray
Write-Host ""


# 5. TOP 5 AUTOREN (NUR HEARD)
Write-Host "  TOP 5 AUTOREN (NUR GEHÖRTE BÜCHER)" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------------------------" -ForegroundColor DarkGray
$topAuthors | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host "   $_" -ForegroundColor White }

Write-Host "==========================================================================" -ForegroundColor DarkCyan
Write-Host ""