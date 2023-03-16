$Username = "%{provided_credential.username}" 
$Password= "%{provided_credential.password}"
$LocalHost = hostname

#Credential Object 
[pscredential]$credential= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$Username",("$Password" | ConvertTo-SecureString -AsPlainText -Force)  

write-host "[$LocalHost] will be dejoined from the domain"

Remove-Computer -UnjoinDomainCredential $Credential -force