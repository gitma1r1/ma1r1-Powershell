-- BMDCloud - SQL Scripts


​​-- Standard BMDNTCS SQL Parameter


-- AD Gruppen anlegen

USE [master]
GO
CREATE LOGIN [ASP01DOM\GruppeMitarbeiter] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO
USE [master]
GO
GRANT VIEW SERVER STATE TO [ASP01DOM\GruppeMitarbeiter]
GO


-- Std. Parameter lt. Migration 

ALTER DATABASE [KUNDENNUMMER] SET COMPATIBILITY_LEVEL = 160
ALTER DATABASE [KUNDENNUMMER] SET AUTO_SHRINK OFF
ALTER DATABASE [KUNDENNUMMER] SET AUTO_CLOSE OFF
ALTER DATABASE [KUNDENNUMMER] SET ALLOW_SNAPSHOT_ISOLATION ON
ALTER DATABASE [KUNDENNUMMER] SET READ_COMMITTED_SNAPSHOT ON
ALTER DATABASE [KUNDENNUMMER] SET PAGE_VERIFY CHECKSUM
ALTER DATABASE [KUNDENNUMMER] SET RECOVERY FULL


-- erweiterte Parameter (ev. nicht notwendig)  

ALTER DATABASE [KUNDENNUMMER] SET ANSI_NULL_DEFAULT OFF
ALTER DATABASE [KUNDENNUMMER] SET ANSI_NULLS OFF
ALTER DATABASE [KUNDENNUMMER] SET ANSI_PADDING OFF
ALTER DATABASE [KUNDENNUMMER] SET ANSI_WARNINGS OFF
ALTER DATABASE [KUNDENNUMMER] SET ARITHABORT OFF
ALTER DATABASE [KUNDENNUMMER] SET AUTO_CREATE_STATISTICS ON
ALTER DATABASE [KUNDENNUMMER] SET AUTO_UPDATE_STATISTICS ON
ALTER DATABASE [KUNDENNUMMER] SET CURSOR_CLOSE_ON_COMMIT OFF
ALTER DATABASE [KUNDENNUMMER] SET CURSOR_DEFAULT  GLOBAL
ALTER DATABASE [KUNDENNUMMER] SET CONCAT_NULL_YIELDS_NULL OFF
ALTER DATABASE [KUNDENNUMMER] SET NUMERIC_ROUNDABORT OFF
ALTER DATABASE [KUNDENNUMMER] SET QUOTED_IDENTIFIER OFF
ALTER DATABASE [KUNDENNUMMER] SET RECURSIVE_TRIGGERS OFF
ALTER DATABASE [KUNDENNUMMER] SET DISABLE_BROKER
ALTER DATABASE [KUNDENNUMMER] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
ALTER DATABASE [KUNDENNUMMER] SET DATE_CORRELATION_OPTIMIZATION OFF
ALTER DATABASE [KUNDENNUMMER] SET TRUSTWORTHY OFF
ALTER DATABASE [KUNDENNUMMER] SET PARAMETERIZATION SIMPLE
ALTER DATABASE [KUNDENNUMMER] SET HONOR_BROKER_PRIORITY OFF
ALTER DATABASE [KUNDENNUMMER] SET MULTI_USER
ALTER DATABASE [KUNDENNUMMER] SET DB_CHAINING OFF
ALTER DATABASE [KUNDENNUMMER] SET READ_WRITE
ALTER DATABASE [KUNDENNUMMER] SET QUERY_STORE = OFF 
ALTER DATABASE [KUNDENNUMMER] SET TARGET_RECOVERY_TIME = 60 SECONDS;
GO


-- AD Gruppen anlegen

USE [KUNDENNUMMER]
GO
CREATE USER [ASP01DOM\GruppeMitarbeiter] FOR LOGIN [ASP01DOM\GruppeMitarbeiter]
GO

USE [KUNDENNUMMER]
GO
EXEC sp_addrolemember N'db_owner', N'ASP01DOM\GruppeMitarbeiter'
GO


-- sp_updatestats

USE [KUNDENNUMMER]
GO
EXEC sp_updatestats;


-- BMD 5.x BMD Verzeichnis
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert = 'O:\' where PAW_PARAMUNTERGRUPPE = '2' and PAW_PARAMGRUPPE = 'tools_params' and PAW_PARAMNR = '1'

-- BMD 5.x Konfigverzeichnis
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert = 'O:\' where PAW_PARAMUNTERGRUPPE = '2' and PAW_PARAMGRUPPE = 'tools_params' and PAW_PARAMNR = '2'

-- BMD 5.x Konfigverzeichnis
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert = 'M:\' where PAW_PARAMUNTERGRUPPE = '2' and PAW_PARAMGRUPPE = 'tools_params' and PAW_PARAMNR = '3'

-- BMD 5.x Netspeed Client
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert = 'Netspeed' where PAW_PARAMUNTERGRUPPE = '2' and PAW_PARAMGRUPPE = 'tools_params' and PAW_PARAMNR = '7'

--Autoupdate Suche deaktivieren
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='0' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=11 and PAW_PARAMNR=1

--Import und Export Pfad hinterlegen
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\Export' where PAW_PARAMGRUPPE='BMD_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=4 and PAW_PARAMNR=5
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\Import' where PAW_PARAMGRUPPE='BMD_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=4 and PAW_PARAMNR=6
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\ExternalChecklistDocuments' where PAW_PARAMGRUPPE='BMD_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=5 and PAW_PARAMNR=3

-- Ask for Backup aktivieren für die Datenbank
update [KUNDENNUMMER].bmd.inp_intparam set inp_intparamwert='1' where INP_INTPARAMGRUPPE='BMDDBTOOLS' and INP_INTPARAMNAME='SETUP_ASKFORBACKUP'

IF NOT EXISTS(SELECT 1 FROM [KUNDENNUMMER].BMD.INP_INTPARAM  WHERE [INP_INTPARAMGRUPPE] = 'BMDTOOLS' AND [INP_INTPARAMNAME] = 'MODALFIX' AND [INP_INTPARAMKEY] = 'BMD')
BEGIN
  INSERT INTO [KUNDENNUMMER].[BMD].[INP_INTPARAM] ([INP_INTPARAMGRUPPE],       [INP_INTPARAMNAME], [INP_INTPARAMKEY], INP_INTPARAMWERT) VALUES('BMDTOOLS', 'MODALFIX', 'BMD', '1');
END;

-- XML Pfad hinterlegen für Bilanz
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\XML\ungeprueft' where PAW_PARAMGRUPPE='BILANZ_PARAMS' and PAW_PARAMUNTERGRUPPE=1 and PAW_PARAMNR=1
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\XML' where PAW_PARAMGRUPPE='BILANZ_PARAMS' and PAW_PARAMUNTERGRUPPE=1 and PAW_PARAMNR=2

-- XML Pfad hinterlegen für FIBU
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='K:\XML' where PAW_PARAMGRUPPE='BUERO_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=1

-- Steuerformulare farblos stellen
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='1' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=1

--Export ohne Excel
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='2' where PAW_PARAMGRUPPE='BMD_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=16 and PAW_PARAMNR=23

-- Archiv Server hinterlegen für Stable

update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='ASP-DMS-Stable' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=2
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='81' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=3
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=18
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='ASP-DMS-Stable' where PAW_PARAMGRUPPE='BMDDOCS_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=3 and PAW_PARAMNR=2
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='81' where PAW_PARAMGRUPPE='BMDDOCS_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=3 and PAW_PARAMNR=3

-- Archiv Server hinterlegen für Latest
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='ASP-DMS-Latest' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=2
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='82' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=3
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='' where PAW_PARAMGRUPPE='TOOLS_PARAMS' and PAW_PARAMUNTERGRUPPE=7 and PAW_PARAMNR=18
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='ASP-DMS-Latest' where PAW_PARAMGRUPPE='BMDDOCS_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=3 and PAW_PARAMNR=2
update [KUNDENNUMMER].bmd.paw_paramwert set paw_paramwert='82' where PAW_PARAMGRUPPE='BMDDOCS_GLOBALPARAMS' and PAW_PARAMUNTERGRUPPE=3 and PAW_PARAMNR=3

-- Archiv TLS aktivieren
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '3' where PAW_PARAMGRUPPE = 'TOOLS_PARAMS' and  PAW_PARAMUNTERGRUPPE = '7' and PAW_PARAMNR = '10'

-- Archivpfade prüfen deaktivieren
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '0' where PAW_PARAMGRUPPE = 'TOOLS_PARAMS' and  PAW_PARAMUNTERGRUPPE = '7' and PAW_PARAMNR = '20'

-- Service verwaltet Log-Dateien deaktivieren 
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '0' where PAW_PARAMGRUPPE = 'TOOLS_PARAMS' and  PAW_PARAMUNTERGRUPPE = '7' and PAW_PARAMNR = '7'

-- vorab die DMS Pfad Nummer prüfen mit folgendem select 
select * from bmd.vpf_vpfad where (upper(vpf_netzpfad) like '%\\%' or upper(vpf_netzpfad) like '%:\%' or upper(vpf_serverpfad) like '%\\%' or upper(vpf_serverpfad) like '%:\%')

-- Archiv Pfade hinterlegen (Std. Pfadnummern!)
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\Document' where VPF_VPFADNR=1
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\EmployeePhoto' where VPF_VPFADNR=2
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\ArticlePhoto' where VPF_VPFADNR=3
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\Invoice' where VPF_VPFADNR=4
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\CheckList' where VPF_VPFADNR=5
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_netzpfad='K:\CheckList' where VPF_VPFADNR=5
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\HelpFiles' where VPF_VPFADNR=6
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\CatalogueArticlePhoto' where VPF_VPFADNR=7
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\CatalogueArticleDocuments' where VPF_VPFADNR=8
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\ResourcesPhoto' where VPF_VPFADNR=9
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\OnlineSurvey' where VPF_VPFADNR=10
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\AssetPhoto' where VPF_VPFADNR=11
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\Elda' where VPF_VPFADNR=12
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\ClientDocs' where VPF_VPFADNR=13
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\CompanyPhoto' where VPF_VPFADNR=14
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\AmountCalculationPhoto' where VPF_VPFADNR=15
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\SignaturePhoto' where VPF_VPFADNR=16
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\EventPhoto' where VPF_VPFADNR=17
update [KUNDENNUMMER].bmd.vpf_vpfad set vpf_serverpfad='K:\DMS\KUNDENNUMMER\SupportTracker' where VPF_VPFADNR=18

-- Archiv Pfade hinterlegen (falls keine Std. Pfadnummern, lt. folgendem Script anpassen)
update bmd.vpf_vpfad set vpf_serverpfad = replace(vpf_serverpfad, 'd:\alter-pfad\', 'K:\DMS\KUNDENNUMMER\Document')
update bmd.vpf_vpfad set vpf_netzpfad = replace(vpf_netzpfad, '\\alter-server\', 'K:\CheckList')

-- Systeminventarisierung deaktivieren
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '0' where PAW_PARAMUNTERGRUPPE = '1' and PAW_PARAMGRUPPE = 'tools_params' and PAW_PARAMNR = '61'

-- Cloud-Explorer Parameter lt. Zauner
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '1' where PAW_PARAMUNTERGRUPPE = '25' and PAW_PARAMGRUPPE = 'TOOLS_PARAMS' and PAW_PARAMNR = '4'
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '20000' where PAW_PARAMUNTERGRUPPE = '25' and PAW_PARAMGRUPPE = 'TOOLS_PARAMS' and PAW_PARAMNR = '6'

-- Datenbanksicherung beim Beenden deaktivieren
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '0' where PAW_PARAMUNTERGRUPPE = '18' and PAW_PARAMGRUPPE = 'BMD_GLOBALPARAMS' and PAW_PARAMNR = '5'
-- kein Hinweis beim Programmende, dass keine gültige Datenbanksicherung vorhanden ist.
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '0' where PAW_PARAMUNTERGRUPPE = '18' and PAW_PARAMGRUPPE = 'BMD_GLOBALPARAMS' and PAW_PARAMNR = '7'
-- Art des Excel-Exports auf "Alternative Komponente" konfigurieren
update [KUNDENNUMMER].BMD.PAW_PARAMWERT set PAW_PARAMWERT = '2' where PAW_PARAMUNTERGRUPPE = '16' and PAW_PARAMGRUPPE = 'BMD_GLOBALPARAMS' and PAW_PARAMNR = '23'

-- Pfade und Servernamen via BMDDBUpdate auslesen und ggf. korrigieren. Suche nach \\ + :\ bzw. alterServer + alteIP
-- Tools Parameter kontrollieren (Sync Service etc.) 

-- buerf Pfad ist immer wieder ein Thema nach Umstellungen -> auch via DBUpdate kontrollieren und ggf. auf K:\Daten anpassen

-- Drucker über folgende SQL Statements prüfen

select * from bil.jab_jabinfo where jab_druckerbez like '%\\%'

select * from bmd.drs_druckereinstellung where (drs_norm_erste_drucker like '%\\%' or drs_norm_rest_drucker like '%\\%' or drs_kopie_erste_drucker like '%\\%' or drs_kopie_rest_drucker like '%\\%')
select * from bmd.dru_drucker where dru_windowsdrucker like '%\\%'
select * from bmd.drz_druckerbenutzerwert where drz_windowsdrucker like '%\\%'
select * from bmd.rpv_reportvorschlag where rpv_druckername like '%\\%'         (war früher select * from bmd.reportvorschlag where druckername like '%\\%')
select * from wws.wad_wwsadresszusatz where (upper(wad_edi_pfad) like '%\\%' or upper(wad_edi_pfad) like '%:\%')

-- und ggf. mit folgenden SQL Statments anpassen

update bil.jab_jabinfo set jab_druckerbez = replace (jab_druckerbez, '\\alte-druckerfreigabe', '\\neue-druckerfreigabe')

update bmd.drs_druckereinstellung set drs_norm_erste_drucker = replace (drs_norm_erste_drucker,'\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.drs_druckereinstellung set drs_norm_rest_drucker = replace (drs_norm_rest_drucker,'\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.drs_druckereinstellung set drs_kopie_erste_drucker = replace (drs_kopie_erste_drucker,'\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.drs_druckereinstellung set drs_kopie_rest_drucker = replace (drs_kopie_rest_drucker,'\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.dru_drucker set dru_windowsdrucker = replace (dru_windowsdrucker, '\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.drz_druckerbenutzerwert set drz_windowsdrucker = replace (drz_windowsdrucker, '\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update bmd.rpv_reportvorschlag set druckername = replace (druckername, '\\alte-druckerfreigabe', '\\neue-druckerfreigabe')                                     
war früher (bmd.reportvorschlag set druckername = replace (druckername, '\\alte-druckerfreigabe', '\\neue-druckerfreigabe')
update wws.wad_wwsadresszusatz set wad_edi_pfad = replace(wad_edi_pfad, '\\alter-server\', '\\neuer-server\')


-- Kontrolle EDI-Pfade:
-- Tools -> Administration -> EDI -> Nachrichtentypen
-- Hier könnte es sein, dass gewisse Nachrichten direkt auf ein Verzeichnis und nicht auf einem FTP Server abgelegt werden. Wenn das der Fall ist, muss unbedingt der Pfad geändert --werden.


-- Kontrolle Buchungserfassungsdateien (Buerf):
-- Bei den Buchungserfassungsdateien ist es ebenfalls so, dass diese auf ein Verzeichnis verweisen.
-- Dieses muss dann in den Parametern geändert werden:
-- Warenwirtschaft à Stammdaten à Einstellungen à WWS-Parameter à Warenwirtschaft allgemein à Firmenbezogene Einstellung (im Normalfall) à Buchungserfassungsdateien
-- Es sollte auch immer nachgefragt werden ob Drucker in Ausdrucksmodelle hinterlegt sind, damit diese entsprechend umgestellt werden

-- FullBackup
-- Bei einer DB Übernahme muss ein Full Backup der Datenbank erstellt werden. 

-- für STABLE ...
BACKUP DATABASE [KUNDENNUMMER] TO DISK = N'S:\SQL-Backup\KUNDENNUMMER\KUNDENNUMMER_Full.bak' WITH NOFORMAT, COMPRESSION, NOINIT, NAME = N'298045-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

-- für LATEST ...
BACKUP DATABASE [KUNDENNUMMER] TO DISK = N'L:\SQL-Backup\KUNDENNUMMER\KUNDENNUMMER_Full.bak' WITH NOFORMAT, COMPRESSION, NOINIT, NAME = N'298045-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO


-- muss unbedingt lt. Zauner gemacht werden
-- Natürlich KdNr anpassen

use [KUNDENNUMMER]
go
ALTER DATABASE [KUNDENNUMMER] SET TARGET_RECOVERY_TIME = 60 SECONDS;
GO

USE [KUNDENNUMMER]
GO
alter database [KUNDENNUMMER] set recovery simple
GO
USE [msdb]
GO
EXEC dbo.usp_AdaptiveIndexDefrag @dbScope ='KUNDENNUMMER', @Exec_Print = 1, @printCmds = 1
GO
DBCC CHECKDB ('KUNDENNUMMER') with physical_only
GO
USE [KUNDENNUMMER]
GO
DBCC Shrinkfile(BMD_LOG,2)
GO
alter database [KUNDENNUMMER] set recovery full
GO

--Sperrgruppen Import

--Stable
\\bmdasp02-stable\bmdntcs_pgm_stable\BMDNTCS.exe /DBALIAS=ASP-SQLCLU1\BMD:KUNDENNUMMER /USERID=BMD /PWD=BMD /FUNC=MCS_MDSECURITY_IMPORT /STP_IMP_FILENAME=\\bmdasp02-stable\bmdntcs_pgm_stable\Daten\Standards\Tools\STD\BMD_SECURITY_STD.BMD /CONST_IMPORT_GR

--Latest
\\bmdasp02-latest\bmdntcs_pgm_latest\BMDNTCS.exe /DBALIAS=ASP-SQLCLU2\LATEST:KUNDENNUMMER /USERID=BMD /PWD=BMD /FUNC=MCS_MDSECURITY_IMPORT /STP_IMP_FILENAME=\\bmdasp02-latest\bmdntcs_pgm_latest\Daten\Standards\Tools\STD\BMD_SECURITY_STD.BMD /CONST_IMPORT_GR


--SQL2SQL

--Stable
"C:\Program Files (x86)\BMDNTCSClients\BMDASP02-Stable\BMDNTCS.exe" /BMDDBTRANSFERI /DB=ASP-SQLCLU1\BMD:KUNDENNUMMER /LOGINMODE=WINDOWS /USER=BMD /PWD=PWD /MASTERDB KUNDENNUMMER /DEFAULTFROMMASTER  /TRANSFERPROCESSES 3 /ALL_OPERATIONS /SFP=SPECIALFEATUREPASSWORD

--Latest
"C:\Program Files (x86)\BMDNTCSClients\BMDASP02-Latest\BMDNTCS.exe" /BMDDBTRANSFERI /DB=ASP-SQLCLU2\LATEST:KUNDENNUMMER /LOGINMODE=WINDOWS /USER=BMD /PWD=PWD /MASTERDB KUNDENNUMMER /DEFAULTFROMMASTER  /TRANSFERPROCESSES 3 /ALL_OPERATIONS /SFP=SPECIALFEATUREPASSWORD