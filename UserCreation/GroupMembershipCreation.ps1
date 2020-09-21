#Import CSV 
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition  
$groupMembershipsPath  = $path + "\GroupMemberships.csv" 
$groupMembershipsCsv      = @() 
$groupMembershipsCsv      = Import-Csv -Path $groupMembershipsPath
 

ForEach ($item in $groupMembershipsCsv)
{
    Try
    {
        #Check if the user exists and if not create them 
        $exists = Get-LocalUser $item.Username -ErrorAction Stop
        Write-Host "User $($item.Username) already exists. User creation skipped." 
    }
    Catch
    {
        #Not found so create them
        New-LocalUser -Name $item.Username -PasswordNeverExpires -Password (ConvertTo-SecureString -AsPlainText "p" -Force) -AccountNeverExpires
    }


    #We can be sure of a user now but not of a group. Create the group if it does not exist
    Try 
    { 
        #Check if the Group already exists 
        $exists = Get-LocalGroup $item.GroupName -ErrorAction Stop
        Write-Host "Group $($item.GroupName) already exists. Group creation skipped." 
    } 
    Catch 
    { 
        #Create the group if it doesn't exist 
        $create = New-LocalGroup -Name $item.GroupName
        Write-Host "Group $($item.GroupName) created." 
    } 


    Try
    {
        Add-LocalGroupMember -Group $item.GroupName -Member $item.Username -ErrorAction Stop
        Write-Host "Successfully added $($item.Username) to $($item.GroupName) group"
    }
    Catch
    {
        Write-Host "User $($item.Username) is already a member of the $($item.GroupName) group - skipping this one"
    }

}
