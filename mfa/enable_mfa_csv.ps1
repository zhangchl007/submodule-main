#$Credential = Get-Credential
# Connect-MsolService -Credential $Credential -AzureEnvironment AzureChinaCloud
Connect-MsolService
$users = Import-Csv C:\temp\enablemfa.csv
foreach ($user in $users)
{
    $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $st.RelyingParty = "*"
    $st.State = "Enabled"
    $sta = @($st)
    Set-MsolUser -UserPrincipalName $user.UserPrincipalName -StrongAuthenticationRequirements $sta

}
Write-Host "DONE RUNNING SCRIPT"