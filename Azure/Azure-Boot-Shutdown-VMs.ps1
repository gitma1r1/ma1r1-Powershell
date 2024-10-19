#Credentials 
(get-credential).password|convertFrom-SecureString|set-content C:\Users\mai156\Desktop\cred-mai156-sp-aztechnik.txt $password = get-content C:\Users\mai156\Desktop\cred-mai156-sp-aztechnik.txt | convertto-securestring $User = "1b61339f4-e188-4d35f-a345d-4e4c92d048692d" $Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $password


# Sign in to your Azure subscription
Connect-AzAccount -Credential $Credential -ServicePrincipal -Tenant "9c8620b7-8359-456b-b0b4-c42a083a95f5" -Subscription "b57b2bbd-a86c-48e5-a1f7-9e9fe20d1e4f"
 #Disconnect-AzAccount

#Stop Stop-AzVM -ResourceGroupName "rg-loi357-prod" -Name "vm-loi357-prod" -Force


 #Start
Start-AzVM -ResourceGroupName "rg-loi357-prod" -Name "vm-mai156-prod"​