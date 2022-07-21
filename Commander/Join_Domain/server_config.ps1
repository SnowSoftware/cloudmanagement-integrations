<#
To configure commander server to use unencrypted connections
- this is for the winRM service and does not expose WinRM on the commander server.
- it's used to run winRM on non-domain joined hosts by IP. After the target host has been joined to the domain it's 
recommended that the domain GPO or workflow disable unencrypted winRM on the target.
#>
$key = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds"
Set-ItemProperty $key ConsolePrompting True
Set-Item WSMan:localhost\client\trustedhosts -value *
winrm set winrm/config/service '@{AllowUnencrypted="true"}'