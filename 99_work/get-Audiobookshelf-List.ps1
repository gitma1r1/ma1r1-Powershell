#Audibookshelf Export List
## export heard und notheard list von Lychee via duckdns link
##########################################################################################################################################

#1. heard - export audiobook list - heard 
$res = ""
$headers = @{ "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXlJZCI6ImVjMWUyM2U0LTkwNGUtNDY1NS1hMzVkLWFjOThiZTRiZDY3MCIsIm5hbWUiOiJ0ZXN0IiwidHlwZSI6ImFwaSIsImlhdCI6MTc4NDYzMzc3M30.2t0rlug-QRPyFhSQFq0oPGvkxUkjelU9nMNEestlbcI" }
$res = Invoke-RestMethod -Uri "http://ma1r1.duckdns.org:13378/api/libraries/34d5d2ff-9610-42fa-921c-8fcac6959250/items?sort=addedAt&desc=0" -Headers $headers
$res.results | Select-Object @{N="Titel"; E={$_.media.metadata.title}}, @{N="Autor"; E={$_.media.metadata.authorName}} | Format-Table -AutoSize

#Anzahl von heard
($res.results).count

##########################################################################################################################################

#2. notherad - export audiobook list - not heard
$res = ""
$headers = @{ "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXlJZCI6ImVjMWUyM2U0LTkwNGUtNDY1NS1hMzVkLWFjOThiZTRiZDY3MCIsIm5hbWUiOiJ0ZXN0IiwidHlwZSI6ImFwaSIsImlhdCI6MTc4NDYzMzc3M30.2t0rlug-QRPyFhSQFq0oPGvkxUkjelU9nMNEestlbcI" }
$res = Invoke-RestMethod -Uri "http://ma1r1.duckdns.org:13378/api/libraries/4dddbc49-d7c9-46e9-8b61-0f26669bcffe/items?sort=addedAt&desc=0" -Headers $headers
$res.results | Select-Object @{N="Titel"; E={$_.media.metadata.title}}, @{N="Autor"; E={$_.media.metadata.authorName}} | Format-Table -AutoSize

#Anzahl von notheard
($res.results).count

##########################################################################################################################################