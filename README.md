------------- 🛡️ Powershell Bunker -------------- 🗺️ Navigation \& Struktur ------------------------

/ (Root)
├── 📂 01_Work_Admin          # 💼 Alles für den Job (BMD, Azure, PRTG, SQL..)
│   ├── ☁️ Azure              # Naming, VM-Skripte, Storage
│   ├── 📊 PRTG               # Custom Sensoren (Adobe, FSLogix, etc.)
│   ├── 🗄️ SQL_BMD            # Migrations-Scripts \& Cloud-Parameter
│   └── 🛠️ Server_Basics      # Taskkill, Eventlog, Netz-Checks
|
├── 📂 02_Library_Functions/        # ⚙️ Wiederverwendbare Power-Tools
|   ├── 🌐 Network_Scanner_V3.ps1   # 🌐 Network Scanner
|    └── 👤 AD_User_Helpers.ps1     # 👤
│
└── 📂 03_Private_Projects/    # 🏠 Deine Spielwiese
│   ├── 🐍 Scripts\_Testing/   # Unfertiges, Experimente
│   └── 🏠 Home\_Lab/          # Alles was du nur privat brauchst
|
└── 📄 README.md                  # 📍 Dieses Menü


-----------------------------------------------------------------------------------------------------
\## 🚀 Daily Survival (Quick Copy) - \*Diese Befehle brauche ich so oft, dass sie direkt hier stehen:\*



\### Prozesse killen (BMD \& Drucker)

```powershell

Taskkill /T /F /IM bmd\*

pskill spoolsv.exe

