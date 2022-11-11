


$linux_diskencrypt_rg= "diskencrypt_rg"
$encrypt_location = "EastUS"
$diskkeyvault = "mydiskencryptkeyvault"
$vm_rg= "IaaS_Jimmy"
$vm_name = "redistest01"
New-AzResourceGroup -Name $linux_diskencrypt_rg -Location $encrypt_location
New-AzKeyvault -name $diskkeyvault -ResourceGroupName $linux_diskencrypt_rg -Location $encrypt_location -EnabledForDiskEncryption
$KeyVault = Get-AzKeyVault -VaultName $diskkeyvault -ResourceGroupName $linux_diskencrypt_rg

Set-AzVMDiskEncryptionExtension -ResourceGroupName $vm_rg -VMName $vm_name -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId -SkipVmBackup -VolumeType All
Get-AzVmDiskEncryptionStatus -VMName $vm_name -ResourceGroupName $vm_rg 

Disable-AzVMDiskEncryption -ResourceGroupName $vm_rg -VMName $vm_name -VolumeType All

New-AzKeyvault -name MyKV -ResourceGroupName myResourceGroup -Location EastUS -EnabledForDiskEncryption

$KeyVault = Get-AzKeyVault -VaultName MyKV -ResourceGroupName MyResourceGroup

Set-AzVMDiskEncryptionExtension -ResourceGroupName MyResourceGroup -VMName MyVM -DiskEncryptionKeyVaultUrl $KeyVault.VaultUri -DiskEncryptionKeyVaultId $KeyVault.ResourceId

Get-AzVmDiskEncryptionStatus -VMName MyVM -ResourceGroupName MyResourceGroup
