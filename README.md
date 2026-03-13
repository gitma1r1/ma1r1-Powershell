\# 🛡️ Powershell Bunker



> \*\*Admin:\*\* ma1r1 | \*\*Status:\*\* Einsatzbereit 🚀 | \*\*Focus:\*\* BMD, Azure \& Automation



---



\## 🗺️ Navigation \& Struktur

```text

/ (Root)

├── 📂 01\_Work\_Admin/         # 💼 Alles für den Job (BMD, Azure, PRTG, SQL)

│   ├── ☁️ Azure/             # Naming, VM-Skripte, Storage

│   ├── 📊 PRTG/              # Custom Sensoren (Adobe, FSLogix, etc.)

│   ├── 🗄️ SQL\_BMD/           # Migrations-Scripts \& Cloud-Parameter

│   └── 🛠️ Server\_Basics/     # Taskkill, Eventlog, Netz-Checks

├── 📂 02\_Private\_Projects/   # 🏠 Deine Spielwiese

│   ├── 🐍 Scripts\_Testing/   # Unfertiges, Experimente

│   └── 🏠 Home\_Lab/          # Alles was du nur privat brauchst

└── 📂 03\_Library\_Functions/  # ⚙️ Wiederverwendbare Power-Tools

|   ├── 🌐 Network\_Scanner\_V3.ps1

|   └── 👤 AD\_User\_Helpers.ps1│

└── 📄 README.md                  # 📍 Dieses Menü



------------------------------------------------



\## 🚀 Daily Survival (Quick Copy) - \*Diese Befehle brauche ich so oft, dass sie direkt hier stehen:\*



\### Prozesse killen (BMD \& Drucker)

```powershell

Taskkill /T /F /IM bmd\*

pskill spoolsv.exe

