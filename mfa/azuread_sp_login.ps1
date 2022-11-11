# Get Tenant.Id
$tenantId = (Get-AzContext).Tenant.Id
# Create service principal (this should only be done once per computer)
$sp = New-AzADServicePrincipal -DisplayName SPN2
$secureString=$sp.PasswordCredentials.SecretText
$appId=$sp.AppId
$Secure=$secureString|ConvertTo-SecureString  -AsPlainText -Force
$pscredential2 = New-Object -TypeName System.Management.Automation.PSCredential($appId, $Secure)
# Silently connect to Azure AD using stored credentials
Connect-AzAccount -ServicePrincipal   -Credential  $pscredential2 -Tenant $tenantId | Out-Null