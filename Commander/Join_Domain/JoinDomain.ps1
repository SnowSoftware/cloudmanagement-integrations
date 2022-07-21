<#
WinRM join domain Module, requires the target to be configured to accept WinRM requests. 
It's recommended that you set the firewall to the commander server only unless required otherwise
Used to run winRM on non-domain joined hosts by IP. After the target host has been joined to the domain it's 
recommended that the domain GPO or workflow disable unencrypted winRM on the target.
#> 

#Commander Base Configuration
$BaseURL = 'https://localhost'
$Commanderuser = (Get-Item Env:SELECTED_CREDENTIALS_USERNAME).value;
$Commanderpass = (Get-Item Env:SELECTED_CREDENTIALS_PASSWORD).value;
$BypassCert = "#{inputVariable['BypassCert']}" 

#VM credential
$vmCredName = "#{inputVariable['vmCredname']}"     #Cred name in the commander credential library

#Domain, Credential and target
$DomaintoJoin = "#{inputVariable['DomaintoJoin']}"
$TargetAddress = "#{target.ipv4Addresses}" 
$Domaincredname = "#{inputVariable['DomainCredName']}"      #Cred name in the commander credential library

#########################################################################################################
#Set-StrictMode -Version 3.0
$ErrorActionPreference = "Stop"

if (!($TargetAddress) -or !($domaincredname) -or !($vmCredName) -or !($DomaintoJoin)) {
    Write-error "Please provide Image and Domain information"
    Exit 1
}

if (!($BaseURL) -or !($Commanderuser) -or !($Commanderpass) -or !($BypassCert)) {
    Write-error "Please provide Commander information"
    Exit 1
}


#ignore Commander unsigned Certificate
if ($BypassCert -eq "Yes") {
    Write-host "- Ignoring invalid Certificate" -ForegroundColor Green

    add-type @"
   using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}

#Get Auth Token
$Token = $null
$TokenEndpoint = "/rest/v3/tokens"
$TokenURL = $BaseURL + $TokenEndpoint
$TokenBody = "{
                ""username"": ""$Commanderuser"",
                ""password"": ""$Commanderpass"" 
                }"
$TokenResult = Invoke-RestMethod -Method POST $TokenURL -Body $TokenBody -ContentType 'application/json'
$Token = $TokenResult.token
$AuthHeader = @{"Authorization" = "Bearer $Token" }

#Get Template Credential
Try {
    $vmcredurl = $BaseURL + "/rest/v3/credentials/$vmcredname"   
    $vmcred = Invoke-RestMethod -Method GET $vmcredurl -Headers $AuthHeader -ContentType 'application/json'
    $vmcreds = $vmcred.password_credential
    $vmusername = $vmcreds.username 
    $vmpassword = $vmcreds.password | ConvertTo-SecureString -AsPlainText -Force
    $vmcredential = New-Object System.Management.Automation.PSCredential($vmusername, $vmpassword)
}
Catch {
    $Exception = "$_"
    Write-Error "Failed to get credential named $vmcredname from credentials in commander.. Does it exist?"
    Write-Error $Exception
    Exit 1   
} 

#Get Domain Credential
Try {
    $credurl = $BaseURL + "/rest/v3/credentials/$domaincredname"   
    $cred = Invoke-RestMethod -Method GET $credurl -Headers $AuthHeader -ContentType 'application/json'
    $creds = $cred.password_credential
    $Domainusername = $creds.username 
    $Domainpassword = $creds.password 
}
Catch {
    $Exception = "$_"
    Write-Error "Failed to get credential named $domaincredname from credentials in commander.. Does it exist?"
    Write-Error $Exception
    Exit 1   
} 


#Open pssession to targetVM
$session = new-pssession -ComputerName $TargetAddress -Credential $vmcredential
$result = invoke-command -session $session -ScriptBlock {   
    #Parameters List
    param ($DomaintoJoin, $Domainusername, $Domainpassword)    
    #Set executionpolicy to bypass warnings in this session
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
    #Domain cred
    $Domainpassword | ConvertTo-SecureString -AsPlainText -Force
    $Domaincred = New-Object System.Management.Automation.PSCredential($Domainusername, $Domainpassword)
    #Join Domain
    try {
        $hostname = hostname
        Write-host "Domain: $DomaintoJoin"
        Add-Computer -ComputerName $hostname -Credential $Domaincred -DomainName $DomaintoJoin -Confirm:$false #  -Restart
    }
    catch {
        $err = $_.Exception
        Write-Host $err.Message
    }
} -ArgumentList ($DomaintoJoin, $Domainusername, $Domainpassword)

Remove-PSSession $TargetAddress