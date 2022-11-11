function Set-MfaState {
     [CmdletBinding()]
     param(
         [Parameter(ValueFromPipelineByPropertyName=$True)]
         $ObjectId,
         [Parameter(ValueFromPipelineByPropertyName=$True)]
         $UserPrincipalName,
         [ValidateSet("Disabled", "Enabled", "Enforced")]
         $State
     )
    
     Process {
         Write-Verbose ("Setting MFA state for user '{0}' to '{1}'." -f $ObjectId, $State)
         $Requirements = @()
         if($State -ne "Disabled") {
             $Requirement = [Microsoft.Online.Administration.StrongAuthenticationRequirement]::new()
             $Requirement.RelyingParty = "*"
             $Requirement.State = $State
             $Requirements += $Requirement
         }
    
         Set-MsolUser -ObjectId $ObjectId -UserPrincipalName $UserPrincipalName -StrongAuthenticationRequirements $Requirements
     }
 }
 
 # Create the password file (this should only be done once per computer)
 #(Get-Credential).Password | ConvertFrom-SecureString | Out-File  "C:\temp\password.txt"

 # Use the password file to authenticate
 $user = "admin@zhangchl007hotmail.onmicrosoft.com"
 $user1= "zhangchl007_hotmail.com#EXT#@zhangchl007hotmail.onmicrosoft.com"
 $password = "C:\temp\password.txt"
 $myCredential = New-Object -TypeName  System.Management.Automation.PSCredential `
 -ArgumentList $user, (Get-Content $password | ConvertTo-SecureString)

 # Silently connect to Azure AD using stored credentials
 Connect-AzureAD -Credential $myCredential -TenantId 637d97ce-8f79-431e-9911-fe29c9ec6a09| Out-Null
 #$ADUsers = Get-ADUser -Filter * -Properties WhenCreated | Where-Object {$_.WhenCreated -gt ([DateTime]::Today)}
 $ADUsers = Get-AzureADUser -All $true | Where-Object {$_.UserType -eq 'Member'}
 if ($ADUsers -ne $null) {
     Connect-MsolService -Credential $myCredential | Out-Null
     foreach($ADUser in $ADUsers) {
         $AzureADUser = Get-MsolUser -UserPrincipalName $ADUser.UserPrincipalName
         if(($ADUser.UserPrincipalName -ne $user) -and ($ADUser.UserPrincipalName -ne $user1)) {
            Write-Output  "enable mfa"
            Set-MfaState -ObjectId $AzureADUser.ObjectId -UserPrincipalName $AzureADUser.UserPrincipalName -State Enabled
         }
        
     }
 }
