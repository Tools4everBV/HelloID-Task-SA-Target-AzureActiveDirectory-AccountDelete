# HelloID-Task-SA-Target-AzureActiveDirectory-AccountDelete
###########################################################
# Form mapping
$formObject = @{
    userId            = $form.userId
    userPrincipalName = $form.userPrincipalName
}

try {
    Write-Information "Executing AzureActiveDirectory action: [DeleteAccount] for: [$($formObject.userPrincipalName)]"
    Write-Information "Retrieving Microsoft Graph AccessToken for tenant: [$AADTenantID]"
    $splatTokenParams = @{
        Uri         = "https://login.microsoftonline.com/$AADTenantID/oauth2/token"
        ContentType = 'application/x-www-form-urlencoded'
        Method      = 'POST'
        Verbose     = $false
        Body = @{
            grant_type    = 'client_credentials'
            client_id     = $AADAppID
            client_secret = $AADAppSecret
            resource      = 'https://graph.microsoft.com'
        }
    }
    $accessToken = (Invoke-RestMethod @splatTokenParams).access_token

    $splatDeleteAccountParams = @{
        Uri     = "https://graph.microsoft.com/v1.0/users/$($formObject.userId)"
        Method  = 'DELETE'
        Verbose = $false
        Headers = @{
            Authorization  = "Bearer $accessToken"
            Accept         = 'application/json'
            'Content-Type' = 'application/json'
        }
    }
    $null = Invoke-RestMethod @splatDeleteAccountParams
    $auditLog = @{
        Action            = 'DeleteAccount'
        System            = 'AzureActiveDirectory'
        TargetIdentifier  = $formObject.userId
        TargetDisplayName = $formObject.userPrincipalName
        Message           = "AzureActiveDirectory action: [DeleteAccount] for: [$($formObject.userPrincipalName)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Information $auditLog.Message
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'DeleteAccount'
        System            = 'AzureActiveDirectory'
        TargetIdentifier  = $formObject.userId
        TargetDisplayName = $formObject.userPrincipalName
        Message           = "Could not execute AzureActiveDirectory action: [DeleteAccount] for: [$($formObject.userPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    if ($($ex.Exception.GetType().FullName -eq 'Microsoft.PowerShell.Commands.HttpResponseException')){
        $auditLog.Message = "Could not execute AzureActiveDirectory action: [DeleteAccount] for: [$($formObject.userPrincipalName)], error: error: $($ex.ErrorDetails)"
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error $auditLog.Message
}
###########################################################
