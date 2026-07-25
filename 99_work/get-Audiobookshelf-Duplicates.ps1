# ==========================================
# AUDIOBOOKSHELF DUPLICATE FINDER
# ==========================================

$headers = @{ "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXlJZCI6ImVjMWUyM2U0LTkwNGUtNDY1NS1hMzVkLWFjOThiZTRiZDY3MCIsIm5hbWUiOiJ0ZXN0IiwidHlwZSI6ImFwaSIsImlhdCI6MTc4NDYzMzc3M30.2t0rlug-QRPyFhSQFq0oPGvkxUkjelU9nMNEestlbcI" }
$baseUrl = "http://ma1r1.duckdns.org:13378"

$libraryIds = @(
    "34d5d2ff-9610-42fa-921c-8fcac6959250", 
    "4dddbc49-d7c9-46e9-8b61-0f26669bcffe"
)

$allBooks = @()

# 1. Alle Bücher aus allen Libs einsammeln
foreach ($libId in $libraryIds) {
    $uri = "$baseUrl/api/libraries/$libId/items?limit=0"
    $response = Invoke-RestMethod -Uri $uri -Headers $headers

    foreach ($item in $response.results) {
        $rawTitle = $item.media.metadata.title
        # Titel säubern für genauen Vergleich (keine Umlaute/Sonderzeichen-Probleme)
        $cleanTitle = ($rawTitle -replace '[^\w]', '').ToLower()

        $allBooks += [PSCustomObject]@{
            Id          = $item.id
            Titel       = $rawTitle
            CleanTitle  = $cleanTitle
            Autor       = $item.media.metadata.authorName
            Bibliothek  = $libId
            Hinzugefuegt= $item.addedAt
        }
    }
}

# 2. Nach gereinigtem Titel gruppieren und Duplikate filtern
$duplicates = $allBooks | Group-Object CleanTitle | Where-Object { $_.Count -gt 1 }

if ($duplicates.Count -gt 0) {
    Write-Host " Mögliche Duplikate gefunden!" -ForegroundColor Red
    
    foreach ($group in $duplicates) {
        Write-Host "`nDoppelter Titel: '$($group.Group[0].Titel)' ($($group.Count)x vorhanden)" -ForegroundColor Cyan
        $group.Group | Select-Object Autor, Bibliothek, Hinzugefuegt | Format-Table -AutoSize
    }
} else {
    Write-Host " keine Duplikate in deinen Bibliotheken gefunden." -ForegroundColor Green
}