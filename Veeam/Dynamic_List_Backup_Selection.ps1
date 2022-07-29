#Veeam Configuration
$VBRServer = "x.x.x.x"
$VBRport = "9392"  #Default port is 9392
$vBRusername = (Get-Item Env:SELECTED_CREDENTIALS_USERNAME).value;
$vBRpassword = (Get-Item Env:SELECTED_CREDENTIALS_PASSWORD).value
$Modules = "Veeam.Backup.PowerShell"
$BypassCert = "Yes"

#Check to make sure required information is present
if(!($vBRusername) -or !($vBRpassword) -or !($VBRServer) -or !($VBRport) -or !($BypassCert)){
        Write-error "Please provide required information to connect to Veeam"
        Exit 1
        } 

$ErrorActionPreference = "STOP"

#Check for PS Module
ForEach($module in $modules){
    if (Get-Module -ListAvailable -Name $Module) {
        Import-Module $module -WarningAction Ignore
        Write-Debug "Module $Module is installed."
    } 
    else {
        Write-Error "Module $module does not appear to be installed, Please install and run again."
        Exit 1
    }
}

#Bypass unsigned Certificates
if ($BypassCert -eq "yes") {
    Write-Debug "- Ignoring invalid Certificate"
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
[Net.ServicePointManager]::Expect100Continue = $true
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

#Connect to vBRserver
    $secpassword = $vBRpassword | ConvertTo-SecureString -AsPlainText -Force
    $vBRcred = New-Object System.Management.Automation.PSCredential($vBRusername, $secpassword)
    Connect-VBRServer -Server $VBRServer -Port $VBRport -Credential $vBRCred
    $vBRSession = Get-VBRServerSession
    if($vBRSession.Server -eq $VBRServer){
        Write-Debug "Connected to Veeam Server at address: $VBRServer"
        } 
    if(!$vBRSession.Server){
        Write-host "Not Connected to $VBRServer, Please contact your Administrator"
        Exit 1
        }

#Get Backup Jobs
    $vbrJobs = (Get-VBRJob).name
    ConvertTo-Json @($vbrJobs)


#Disconnect Veeam Session
    Disconnect-VBRServer