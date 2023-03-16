$Domain = "#{inputVariable['Domain']}"
$OUPath = "#{inputVariable['OU']}"
$Username = "%{provided_credential.username}" 
$Password= "%{provided_credential.password}"
$LocalHost = hostname

#Credential Object 
[pscredential]$credential= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$Username",("$Password" | ConvertTo-SecureString -AsPlainText -Force)  

if ($OUPath)
    {
        write-host "[$localhost] will be joined to domain [$Domain] in OU path [$OU] and then [$localhost] will be restarted"        
        Add-Computer -DomainName $Domain -OUPath $OUPath -credential $Credential -restart -force
    }
else
    {
        write-host "[$localhost] will be joined to domain [$Domain] in your default OU and then [$localhost] will be restarted"        
        Add-Computer -DomainName $Domain -credential $Credential -restart -force
    }


