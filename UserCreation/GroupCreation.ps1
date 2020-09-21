#Import CSV 
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition  
$newpath  = $path + "\Groups.csv" 
$csv      = @() 
$csv      = Import-Csv -Path $newpath 
 
#Loop through all items in the CSV 
ForEach ($item In $csv) 
{ 
    Try 
    { 
        #Check if the Group already exists 
        $exists = Get-LocalGroup $item.GroupName -ErrorAction Stop
        Write-Host "Group $($item.GroupName) alread exists. Group creation skipped." 
    } 
    Catch 
    { 
        #Create the group if it doesn't exist 
        $create = New-LocalGroup -Name $item.GroupName
        Write-Host "Group $($item.GroupName) created." 
    } 
} 