<#
Requirements
- In Snow Commander the Advanced Property “embotics.workflow.script.credentials” must be set to true.
- In some cases the Execution Policy on the Commander Server must be set to “Unrestricted”
- Commander 8.10.6 or greater
- Minimum Veeam Backup and Recovery Console 11 on the Commander server.
#>

#Veeam Configuration
$VBRServer = "#{inputVariable['vbrServer']}"
$VBRport = "#{inputVariable['vbrPort']}" #Default port is 9392
$vBRusername = (Get-Item Env:SELECTED_CREDENTIALS_USERNAME).value;
$vBRpassword = (Get-Item Env:SELECTED_CREDENTIALS_PASSWORD).value
$Modules = "Veeam.Backup.PowerShell"
$BypassCert = "Yes"
$Jobname = "#{inputVariable['vbrJobName']}"
$VMDetails = "#{target.deployedName}"

#Check to make sure required information is present
if (!($vBRusername) -or !($vBRpassword) -or !($VBRServer) -or !($VBRport) -or !($Jobname) -or !($BypassCert)) {
    Write-error "Please provide required information to connect to Veeam"
    Exit 1
} 

$ErrorActionPreference = "STOP"

#Check for PS Module
ForEach ($module in $modules) {
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
    [Net.ServicePointManager]::Expect100Continue = $true
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

#Connect to vBRserver
$secpassword = $vBRpassword | ConvertTo-SecureString -AsPlainText -Force
$vBRcred = New-Object System.Management.Automation.PSCredential($vBRusername, $secpassword)
Connect-VBRServer -Server $VBRServer -Port $VBRport -Credential $vBRCred
$vBRSession = Get-VBRServerSession
if ($vBRSession.Server -eq $VBRServer) {
    Write-host "Connected to Veeam Server at address: $VBRServer"
} 
if (!$vBRSession.Server) {
    Write-host "Not Connected to $VBRServer, Please contact your Administrator"
    Exit 1
}

#Check if job exists
$vbrJobs = (Get-VBRJob).name
if ($vbrJobs -notcontains $Jobname) {
    Write-host "Backup job '$jobname' doesn't exist on the server, please contact your administrator"
    Disconnect-VBRServer
    Exit 1
}
    
#Add VM to Backup Job
$vmEntity = Find-VBRViEntity -name $VMDetails
IF (!$vmEntity) {
    Write-host "No vm found with the name: $VMDetails" -foreground "red"
    Disconnect-VBRServer
    Exit 1
}
$AddResult = Add-VBRViJobObject -Job $Jobname -Entities $vmEntity -Force -WarningAction Ignore

#Check job for added VM
$jobobject = $jobname | Get-VBRJobObject | where { $_.name -match $vmEntity.name }
If ($jobobject.Name -eq $VMDetails) {
    Write-host "'$VMDetails' succesfully added to backup job: $jobname"
    Disconnect-VBRServer
}
Elseif (!$jobobject) {
    Write-Error "'$VMDetails' succesfully added to backup job: $jobname"
    Disconnect-VBRServer
    Exit 1
}
Else {
    Write-Error "Something has gone wrong, Please contact your system administrator"
    Disconnect-VBRServer
}
