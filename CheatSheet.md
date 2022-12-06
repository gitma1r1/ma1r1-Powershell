Poweshell Cheat Sheet

#get public ip
(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
