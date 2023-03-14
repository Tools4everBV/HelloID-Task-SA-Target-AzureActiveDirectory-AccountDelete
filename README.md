# HelloID-Task-SA-Target-AzureActiveDirectory-AccountDelete

## Prerequisites

Before using this snippet, verify you've met with the following requirements:

- [ ] AzureAD app registration
- [ ] The correct app permissions for the app registration
- [ ] User defined variables: `AADTenantID`, `AADAppID` and `AADAppSecret` created in your HelloID portal.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties to delete a user account, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "UserPrincipalName": "JohnDoe@domain",
    "UserId": "4fca2ec0-4b36-469d-80b3-aa8df406971d",
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.

2. Receive a bearer token by making a POST request to: `https://login.microsoftonline.com/$AADTenantID/oauth2/token`, where `$AADTenantID` is the ID of your Azure Active Directory tenant.

3. Delete the user account using the: `Invoke-RestMethod` cmdlet.
