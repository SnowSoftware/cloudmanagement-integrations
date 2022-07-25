<#
Azure Generic Resource CR - Get Azure Security Group Policy (XaaS Example)
* Commander 8.9.0 or higher
* Advanced property \"embotics.workflow.script.credentials\" must be set to \"true\"
* Requires one form attribute (refer to the associated Change Request form for more info):
    - Port
#> 

# Target info
$deployedName = "#{target.deployedName}"
$resourceGroup = "#{target.resourceGroup.name}" 
$targetType = "#{target.context.type}"
$supportedTargetType = "Microsoft.Network/networkSecurityGroups"

# Input Field
$PortNumber = "#{target.settings.inputField['Port Number']}"

# Azure connection info
$subscriptionId = (Get-Item Env:AZURE_SUBSCRIPTION_ID).value 
$tenantId = (Get-Item Env:AZURE_TENANT_ID).value 
$apiKey = (Get-Item Env:AZURE_API_KEY).value 
$ApplicationId = (Get-Item Env:AZURE_APPLICATION_ID).value

if (!($subscriptionId) -or !($tenantId) -or !($apiKey) -or !($ApplicationId) -or !($PortNumber)) { 
    Write-Error "Please provide Azure Login inforrmation" 
    Exit 1
}
if ($targetType -ne $supportedTargetType) {
    Write-Error "This script only supports resources of type $($supportedTargetType). The type selected was $($targetType)."
    Exit 1
}


#Credential Object
[pscredential]$credential= New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$applicationId",("$apiKey" | ConvertTo-SecureString -AsPlainText -Force) 

#Connect to Azure
$connect = Connect-AzAccount -Credential $credential -Subscription $subscriptionId -Tenant $tenantId -ServicePrincipal -Confirm:$false -WarningAction Ignore
if($connect){
    Write-Debug "Connected to $($connect[0].Context.Environment.name)"
}


# Get the NSG Details
$SecurityRulesArray = @()
$NSGDetails = Get-AzNetworkSecurityGroup -Name  $deployedName -ResourceGroupName $resourceGroup 
$NSGSecurityRules = $NSGDetails | select-object SecurityRules -ExpandProperty SecurityRules

# Loop through each rule looking for the specific port
foreach($NSGSecurityRule in $NSGSecurityRules)
    {
        if(($NSGSecurityRule.DestinationPortRange -like "*-*") -or ($NSGSecurityRule.DestinationPortRange -like "*,*"))
            {
                if($NSGSecurityRule.destinationPortRange -like "*-*")
                    {
                        [string]$NSGPortRanges = $NSGSecurityRule.destinationPortRange
                        $NSGPortRangesArray = $NSGPortRanges.split(" ")
                            foreach($NSGPortRangeArrayItem in $NSGPortRangesarray)
                                {                                
                                    if($NSGPortRangeArrayItem -like "*-*")
                                        {
                                            write-host "Checking Destination Port Range [$NSGPortRangeArrayItem]" 
                                            $PortRangeSplitPosition = $NSGPortRangeArrayItem.IndexOf("-")
                                            [int32]$StartPortRange = $NSGPortRangeArrayItem.SubString(0, $PortRangeSplitPosition)
                                            [int32]$EndPortRange = $NSGPortRangeArrayItem.SubString($PortRangeSplitPosition+1)
                                            [int32]$LoopNumber = $StartPortRange
                                            
                                           
                                            if (($LoopNumber -le $EndPortRange) -and ($LoopNumber -ge $StartPortRange))
                                                {
                                                    do
                                                        {
                                                        
                                                        if($LoopNumber -eq $PortNumber)
                                                            {
                                                            write-host "[$PortNumber] located in your Destination Port Range [$NSGPortRangeArrayItem]"
                                                            $ruleinformation = [ordered]@{
                                                            'Name' = $NSGSecurityRule.Name
                                                            'Direction' = $NSGSecurityRule.Direction
                                                            'Priority' = $NSGSecurityRule.Priority
                                                            'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                                                            'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                                                            'Protocol' = $NSGSecurityRule.Protocol
                                                            'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                                                            'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                                                            'Access' = $NSGSecurityRule.Access
                                                            '----------' = "----------"
                                                            } 
                                                        $SecurityRulesArray += $ruleinformation
                                                        
                                                        
                                                            }
                                                            $LoopNumber++
                                                        }
                                            while ($LoopNumber -le $EndPortRange)
                                                }
                                        }
                                        elseif($NSGSecurityRule.DestinationPortRange -like "*-*")
                                        {
                                            [string]$NSGPortRanges = $NSGSecurityRule.DestinationPortRange
                                            $NSGPortRangesArray = $NSGPortRanges.split(" ")
                                                foreach($NSGPortRangeArrayItem in $NSGPortRangesarray)
                                                    {
                                                                                        
                                                        if($NSGPortRangeArrayItem -notlike "*-*")
                                                            {
                                                                write-host "Checking comma separated items in your range [$NSGPortRangeArrayItem]" 
                                                                if ($NSGPortRangeArrayItem -eq $PortNumber)
                                                                    {
                                                                                write-host "Located port [$PortNumber] as part of your range" 
                                                                                $ruleinformation = [ordered]@{
                                                                                'Name' = $NSGSecurityRule.Name
                                                                                'Direction' = $NSGSecurityRule.Direction
                                                                                'Priority' = $NSGSecurityRule.Priority
                                                                                'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                                                                                'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                                                                                'Protocol' = $NSGSecurityRule.Protocol
                                                                                'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                                                                                'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                                                                                'Access' = $NSGSecurityRule.Access
                                                                                '----------' = "----------"
                                                                                } 
                                                                            $SecurityRulesArray += $ruleinformation
                                                                    }
                                                                               
                                                            }
                                                    }
                                        }
                                }
                    }
            }
            elseif(($NSGSecurityRule.SourcePortRange -like "*-*") -or ($NSGSecurityRule.SourcePortRange -like "*,*"))
            {
                if($NSGSecurityRule.SourcePortRange -like "*-*")
                    {
                        [string]$NSGPortRanges = $NSGSecurityRule.SourcePortRange
                        $NSGPortRangesArray = $NSGPortRanges.split(" ")
                            foreach($NSGPortRangeArrayItem in $NSGPortRangesarray)
                                {
                                     write-host "Checking Source Port Range $NSGPortRangeArrayItem"                                 
                                    if($NSGPortRangeArrayItem -like "*-*")
                                        {
                                            $PortRangeSplitPosition = $NSGPortRangeArrayItem.IndexOf("-")
                                            [int32]$StartPortRange = $NSGPortRangeArrayItem.SubString(0, $PortRangeSplitPosition)
                                            [int32]$EndPortRange = $NSGPortRangeArrayItem.SubString($PortRangeSplitPosition+1)
                                            [int32]$LoopNumber = $StartPortRange
                                                                                       
                                            if ($LoopNumber -ne $PortNumber)
                                                {
                                                    do
                                                        {
                                                        if($LoopNumber -eq $PortNumber)
                                                            {
                                                            write-host "[$PortNumber] located in your Destination Port Range [$NSGPortRangeArrayItem]" 
                                                            $ruleinformation = [ordered]@{
                                                            'Name' = $NSGSecurityRule.Name
                                                            'Direction' = $NSGSecurityRule.Direction
                                                            'Priority' = $NSGSecurityRule.Priority
                                                            'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                                                            'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                                                            'Protocol' = $NSGSecurityRule.Protocol
                                                            'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                                                            'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                                                            'Access' = $NSGSecurityRule.Access
                                                            '----------' = "----------"
                                                            } 
                                                        $SecurityRulesArray += $ruleinformation
                                                        
                                                            }
                                                            $LoopNumber++
                                                        }
                                            while ($LoopNumber -le $EndPortRange)
                                                }
                                        }
                                        elseif($NSGSecurityRule.SourcePortRange -like "*-*")
                                        {
                                            [string]$NSGPortRanges = $NSGSecurityRule.SourcePortRange
                                            $NSGPortRangesArray = $NSGPortRanges.split(" ")
                                                foreach($NSGPortRangeArrayItem in $NSGPortRangesarray)
                                                    {
                                                         write-host "Checking Source Port range $NSGPortRangeArrayItem"                                 
                                                        if($NSGPortRangeArrayItem -notlike "*-*")
                                                            {
                                                                                                                                                       
                                                                if ($NSGPortRangeArrayItem -eq $PortNumber)
                                                                    {
                                                                                write-host "[$PortNumber] located in your Destination Port Range [$NSGPortRangeArrayItem]" 
                                                                                $ruleinformation = [ordered]@{
                                                                                'Name' = $NSGSecurityRule.Name
                                                                                'Direction' = $NSGSecurityRule.Direction
                                                                                'Priority' = $NSGSecurityRule.Priority
                                                                                'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                                                                                'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                                                                                'Protocol' = $NSGSecurityRule.Protocol
                                                                                'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                                                                                'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                                                                                'Access' = $NSGSecurityRule.Access
                                                                                '----------' = "----------"
                                                                                } 
                                                                            $SecurityRulesArray += $ruleinformation
                                                                    }
                                                                               
                                                            }
                                                    }
                                        }
                                }
                    }
            }
            elseif($NSGSecurityRule.SourcePortRange -eq $PortNumber)
            {
                write-host "Individual port located in Source Range [$NSGSecurityRule.SourcePortRange]" 
                $ruleinformation = [ordered]@{
                'Name' = $NSGSecurityRule.Name
                'Direction' = $NSGSecurityRule.Direction
                'Priority' = $NSGSecurityRule.Priority
                'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                'Protocol' = $NSGSecurityRule.Protocol
                'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                'Access' = $NSGSecurityRule.Access
                '----------' = "----------"
                                        } 
                $SecurityRulesArray += $ruleinformation
            }
            elseif($NSGSecurityRule.DestinationPortRange -eq $PortNumber)
            {
                write-host "Individual port located in Source Range [$NSGSecurityRule.DestinationPortRange]" 
                $ruleinformation = [ordered]@{
                'Name' = $NSGSecurityRule.Name
                'Direction' = $NSGSecurityRule.Direction
                'Priority' = $NSGSecurityRule.Priority
                'SourcePortRange' = $NSGSecurityRule.SourcePortRange
                'DestinationPortRange' = $NSGSecurityRule.DestinationPortRange
                'Protocol' = $NSGSecurityRule.Protocol
                'SourceAddressPerfix' = $NSGSecurityRule.SourceAddressPrefix
                'DestinationAddressPrefix' = $NSGSecurityRule.DestinationAddressPrefix
                'Access' = $NSGSecurityRule.Access
                '----------' = "----------"
                                        } 
                $SecurityRulesArray += $ruleinformation
            }
            
    }                    
    
    if($SecurityRulesArray)
    {
        $SecurityRulesArray
    }
Else
    {
        write-host "There are no rules that have your selected port [$PortNumber] in either source or destination port ranges inbound or outbound"   
    }