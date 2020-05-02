# Platform Windows Server 2016 Datacenter
# VM : Standard B2ms (2 vcpus, 8 GiB memory)
# Author : Bahadir YILMAZ
# Date : 30/04/2020

# Deployment without Public IP for Security  :)
cls

Login-AzAccount

Get-AzSubscription 
# Select Subscription from list
Select-AzSubscription -Subscription "02c48a3b-8044-4630-9e40-60f25ddf05d2" # Please change it!

# Variables for common values
$resourceGroup=Read-Host "Type name for create a new Resource Group?"
$location=Read-Host "Choose the Azure region that's right for you and your customers? for ex: westeurope..etc"
$vmName1=Read-Host "Type name for create 1. Virtual Machine name?"
$vmName2=Read-Host "Type name for create 2. Virtual Machine name?"


# Create Credential for VM
$cred = Get-Credential -Message "Enter a username and password for the virtual machines."

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 10.0.0.0/24

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name MYvNET -AddressPrefix 10.0.0.0/16 -Subnet $subnetConfig

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name myNetworkSecurityGroup

# Create a virtual network cards and associate with NSG
$nic = New-AzNetworkInterface -Name myNic -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -NetworkSecurityGroupId $nsg.Id

$nic2 = New-AzNetworkInterface -Name myNic2 -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -NetworkSecurityGroupId $nsg.Id

# Create a virtual machines configuration
$vmConfig1 = New-AzVMConfig -VMName $vmName1 -VMSize Standard_B2ms | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName1 -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id 

$vmConfig2 = New-AzVMConfig -VMName $vmName2 -VMSize Standard_B2ms | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName2 -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic2.Id

# Create a virtual machines
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig1
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig2
