# Replace 'Group1Name', 'Group2Name', etc. with the names of the groups you want to export the members of
$GroupNames = "Group1Name", "Group2Name", "Group3Name"
# Replace 'OutputFolderPath' with the path where you want to save the CSV files
$OutputFolderPath = "OutputFolderPath"
# Loop through each group and export the members to a separate CSV file
foreach ($GroupName in $GroupNames) {
    # Get the members of the group
    $GroupMembers = Get-ADGroupMember -Identity $GroupName
    # Loop through each member and retrieve their first name, last name, and email address
    $MemberDetails = foreach ($Member in $GroupMembers) {
        $User = Get-ADUser -Identity $Member.SamAccountName -Properties GivenName, Surname, EmailAddress
        [PSCustomObject]@{
            FirstName = $User.GivenName
            LastName = $User.Surname
            Email = $User.EmailAddress
        }
    }
    # Export the member details to a CSV file
    $OutputFilePath = Join-Path $OutputFolderPath "$GroupName.csv"
    $MemberDetails | Export-Csv -Path $OutputFilePath -NoTypeInformation
}

#This is test todo