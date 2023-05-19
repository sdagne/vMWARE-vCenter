# Connect to the source vCenter
$sourceServer = "source_vcenter_address"
$sourceUser = "source_username"
$sourcePassword = "source_password"
Connect-VIServer -Server $sourceServer -User $sourceUser -Password $sourcePassword

# Connect to the destination vCenter
$destinationServer = "destination_vcenter_address"
$destinationUser = "destination_username"
$destinationPassword = "destination_password"
Connect-VIServer -Server $destinationServer -User $destinationUser -Password $destinationPassword

# Specify the name of the template to be transferred
$templateName = "template_name"

# Get the source template
$template = Get-Template -Name $templateName

# Clone the template to the destination vCenter
$destinationFolder = "destination_folder_name"
$destinationDatastore = "destination_datastore_name"
$destinationHost = "destination_host_name"

$cloneSpec = New-Object VMware.Vim.VirtualMachineCloneSpec
$cloneSpec.Location = New-Object VMware.Vim.VirtualMachineRelocateSpec
$cloneSpec.Location.Datastore = Get-Datastore -Name $destinationDatastore
$cloneSpec.Location.Host = Get-VMHost -Name $destinationHost
$cloneSpec.Location.Folder = Get-Folder -Name $destinationFolder
$cloneSpec.PowerOn = $false

$clonedTemplate = $template | New-VM -Name $templateName -Location $cloneSpec.Location.Folder -VMHost $cloneSpec.Location.Host -Datastore $cloneSpec.Location.Datastore -RunAsync

# Monitor the progress of the clone operation
while ($clonedTemplate.ExtensionData.Runtime.PowerState -ne "poweredOff") {
    Start-Sleep -Seconds 5
    $clonedTemplate.RefreshData()
}

# Disconnect from both vCenters
Disconnect-VIServer -Server $sourceServer -Confirm:$false
Disconnect-VIServer -Server $destinationServer -Confirm:$false
