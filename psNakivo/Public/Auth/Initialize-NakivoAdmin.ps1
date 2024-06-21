<#
.SYNOPSIS
    Sets the password for the nakivo admin if it has not been set before
.DESCRIPTION
    Sets the password for the nakivo admin if it has not been set before. This skips the "Create User" page on the first login
.NOTES
    Although it is technically not neccessary to already be authenticated in order to use this command, this command assumes that you've called "Connect-Nakivo" before. That is because "Connect-Nakivo" stores some internal values about the Nakivo-Servers Uri, so that you do not need to pass them to every command you execute.
    If you want to workaround this and do not wish to call "Nakivo-Connect" before using this you can use the parameter "ServerUri" (see below).
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Initialize-NakivoAdmin.md
.PARAMETER Username
    Username for the new admin
.PARAMETER Password
    Password for new admin as a SecureString-Object
.PARAMETER Credential
    Credential-Object which holds the information for creating the new admin
.PARAMETER Mail
    Mail-Address of the admin
.PARAMETER EC2ID
    ID of the Amazon EC2 Instance
.PARAMETER ServerUri
    Override the Uri of the nakivo instance. Use this if you do not want to use "Connect-Nakivo" before using this command.
.EXAMPLE
    Initialize-NakivoAdmin -Username "admin" -Password ("nakivo" | ConvertTo-SecureString -AsPlainText -Force) -Mail "admin@localhost"
    Creates the new admin with the corresponding values
#>
function Initialize-NakivoAdmin {
    [CmdletBinding()]
    [OutputType($null)]
    param (
        [Parameter(
            HelpMessage = "Username which will be used for the login",
            Mandatory = $true,
            ParameterSetName = "User_Password"
        )]
        [String] $Username,

        [Parameter(
            HelpMessage = "Password for the user. Leave empty if no password was configures",
            Mandatory = $false,
            ParameterSetName = "User_Password"
        )]
        [securestring] $Password,

        [Parameter(
            HelpMessage = "Credential-Object which holds the user information for logging in",
            Mandatory = $true,
            ParameterSetName = "Credential"
        )]
        [pscredential] $Credential,

        [Parameter(
            HelpMessage = "Mail address of the admin",
            Mandatory = $true
        )]
        [String] $Mail,

        [Parameter(
            Mandatory = $false
        )]
        [String] $EC2ID,

        [Parameter(
            Mandatory = $false
        )]
        [String] $ServerUri
    )

    process {

        if ( [String]::IsNullOrWhiteSpace($ServerUri) -and [String]::IsNullOrWhiteSpace($script:ApiBaseUrl) ) {
            Throw "You do not seem to be connected to a nakivo instance. Please use 'Connect-Nakivo' or use the 'ServerUri' Parameter"
        }

        $WebSplat = @{
            Body = @{
                action = "RegistrationManagement"
                method = "register"
                type = "rpc"
                tid = 1
                data = $null
            }
            Uri = $script:ApiBaseUrl + "c/router"
        }

        if ( -not [String]::IsNullOrWhiteSpace($ServerUri) ) {
            $WebSplat.Uri = $ServerUri.TrimEnd("/") + "/c/router"
        }

        if ($PSCmdlet.ParameterSetName -eq "Credential") {
            $WebSplat.Body.data = @( $Credential.UserName, $Credential.GetNetworkCredential().Password, $Mail, $EC2ID )
        } else {
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)

            $WebSplat.Body.data = @( $UserName, [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR), $Mail, $EC2ID )

            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        }

        $WebSplat.Body = $WebSplat.Body | ConvertTo-Json

        Write-Debug "Trying to register new admin for first start"

        try {
            $result = Invoke-NakivoAPI $WebSplat

            if ($null -ne $result.message) {
                Write-Error "Creating new admin for nakivo failed: $($result.message)"
            }
        } catch {
            Write-Error "Unexpected error while creating new admin for nakivo: $_"
        }

    }
}
