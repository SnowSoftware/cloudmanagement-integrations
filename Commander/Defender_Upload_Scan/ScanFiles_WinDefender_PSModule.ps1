#How it Works:
# We scan the upload directory with Windows Defender. We then check the detected threats and see if any match the files we
# uploaded.
# If any match, we fail the workflow. 
# No remediation of threats is requried as Windows Defender will quarantene or delete the files on it's own.

#get the datetime of the service request
$requstDateTimeString = "#{request.requestDate}"
$requstDateTime = Get-Date -Date $requstDateTimeString

#subtract 5 minutes from the request time and save the new time. We use this time to compare to the detection time of the threats so that
# we can find items uploaded as part of the service request but won't find items which are much older.
$checkedTime = $requstDateTime.AddMinutes(-5)

#set the path to files, default path is \<commander install folder>\tomcat\temp
$uploadFilePath = "#{system.directory}\temp"

#get the list of filenames from the request as a comma separated list
$fileNameString =  "#{inputVariable['file_names']}"

#split the list into an array of strings
$fileNameArray = $fileNameString.Split(',')

#validate that we have files to process
if($fileNameArray.Length -lt 1)
{
    #no files are present, exit the script with a success condition
    write-host "No files were provided for scanning, workflow will exit"
    Exit 0
}

#invoke the scanner on the tomcat temp folder. This will detect any issues with the uploaded files
Start-MpScan -ScanType CustomScan -ScanPath $uploadFilePath

#get the current threat history
$threatHistory = Get-MpThreatDetection

#for each file, invoke the scanner
foreach($fileName in ($fileNameArray | where {$_.Trim() -notlike ""}))
{
    $threatDetected = $false
    #trim the filename for whitespace
    $trimmedName = $fileName.Trim()
    #look up the file
    $individualFilePath = "$uploadFilePath\$trimmedName"
    
    write-host "Checking threat history for $individualFilePath"

    #look for the file in the threat history
    foreach($threat in $threatHistory)
    {
        
        #if the uploaded file appears as a resource in the threat, we found a match
        # We only observe issues which are found after the files were uploaded as part of the request to eliminate false positives on old files with the same name
        if(($threat.Resources | where{$_.contains($individualFilePath)}) -and ($threat.InitialDetectionTime -ge $checkedTime))
        {            
            #set error flags
            $threatDetected = $true
            $scanError = $true
        }
    }

    if($threatDetected -eq $true)
    {
        #write an error message
        write-host "An issue was found in $trimmedName"
    }

}

#if errors are detected
if($scanError -eq $true)
{
    #exit with error
    write-host "Some files contained issues, this workflow will terminate"
    Exit 1

}

write-host "No threats were detected"


