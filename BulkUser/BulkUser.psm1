Function BulkUser{
[CmdletBinding()]
Param
([Parameter (mandatory=$true, Position = 0, Helpmessage="URL for the Site")]
[String]$SiteURL)
Try{
Add-PSSnapin Microsoft.SharePoint.PowerShell –erroraction SilentlyContinue
 
#Variables
$UserListCSV = "$env:HOMEDRIVE\users\$env:USERNAME\Documents\upload.csv"
IF(!$SiteURL){
$SiteURL =READ-host "Enter site URL Example: https://portal.sharepoint.fus.com/sites/TST" 
Write-host  "$SiteURL" -ForegroundColor Green
}
# Import the CSV file
$UserList = Import-CSV $UserListCSV #-header("GroupName","UserAccount") #- If CSV doesn't has headers
 
#Get the Web
$Web = Get-SPWeb $SiteURL}
Catch{Write-Host "An Error Occurred" -ForegroundColor Red
$Error
}
 
#Iterate through each user from CSV file
foreach ($user in $UserList)
{
    Try{
    #Get the Group and User
    $Group = $web.SiteGroups[$User.GroupName]
    $User = $web.Site.RootWeb.EnsureUser($User.UserAccount)
    #Add user to Group
    $Group.AddUser($User)
 
    Write-Host "$($User) Added to $group Successfully!" -ForegroundColor Green
    }
    Catch{
    Write-Host "there was an error! $($user.useraccount)"
    $notUploaded+=($user.Useraccount)
        }
}
 
#Dispose web object
write-host "these Users where not uploaded:"
Write-host "$notuploaded"
$Web.Dispose()

}
