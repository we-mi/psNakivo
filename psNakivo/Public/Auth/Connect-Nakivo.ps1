<#
.SYNOPSIS
    Connect to a nakivo instance
.DESCRIPTION
    Connect to a nakivo instance. Use this function before using any other nakivo-function
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Connect-Nakivo.md
.PARAMETER Server
    Server name or ip of the nakivo instance
.PARAMETER Port
    TCP Port number of the nakivo instance. Defaults to 4443
.PARAMETER SSL
    Use SSL (https) for the connection. Defaults to $True
.PARAMETER Username
    Username which will be used for the login
.PARAMETER Password
    Password for the user as a SecureString-Object. Leave this empty if no password was configured.
.PARAMETER Credential
    Credential-Object which holds the user information for logging in. Can't be used if no password was configured.
.PARAMETER Remember
    Keep the user logged in. Default is logging out after 10 minutes
.PARAMETER SkipCertificateCheck
    Do not check the servers ssl certificate. You should not use this in productive environments
.PARAMETER PassThru
    Send the output object back to stdout
.PARAMETER Multitenancy
    Specify if the nakivo instance you want to connect to is a multi-tenant-installation. Defaults to $False
.EXAMPLE
    Connect-Nakivo -Server nakivo.example.com -Username admin -Password ( "mysuperstrongpassword" | ConvertTo-SecureString -AsPlainText -Force)
    Connect to the nakivo instance at `nakivo.example.com` as user `admin` with the provided password. Use SSL (https) for the connection and check for a valid ssl certificate
.EXAMPLE
    Connect-Nakivo -Server nakivo.example.com -Username admin -Password ( "mysuperstrongpassword" | ConvertTo-SecureString -AsPlainText -Force) -SkipCertificateCheck
    Connect to the nakivo instance at `nakivo.example.com` as user `admin` with the provided password. Use SSL (https) for the connection but skip ssl certificate validation
.EXAMPLE
    Connect-Nakivo -Server nakivo.example.com -Credential $Credential -Port 80 -SSL $false -Remember
    Connect to the nakivo instance at `nakivo.example.com` with the provided credentials. Do not use SSL and connect to the custom port 80. Remember the connection (default is being logged out after 10 minutes)
#>
function Connect-Nakivo {
    [CmdletBinding(DefaultParameterSetName="Credential")]
    [OutputType("Nakivo.User")]
    param (
        [Parameter(
            HelpMessage = "Server name or ip of the nakivo instance",
            Mandatory = $true,
            Position = 0
        )]
        [String] $Server,

        [Parameter(
            Mandatory = $false
        )]
        [ValidateRange(1, 65535)]
        [int] $Port = 4443,

        [Parameter(
            Mandatory = $false
        )]
        [bool] $SSL = $true,

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
        [AllowNull()]
        [securestring] $Password,

        [Parameter(
            HelpMessage = "Credential-Object which holds the user information for logging in",
            Mandatory = $true,
            ParameterSetName = "Credential"
        )]
        [pscredential] $Credential,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $Remember,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $SkipCertificateCheck,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $MultiTenancy,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $PassThru
    )

    process {
        $script:SkipCertificateCheck = $SkipCertificateCheck.ToBool()

        if ($SSL) {
            $script:ApiBaseUrl = "https://$($Server):$($Port)/"
        } else {
            $script:ApiBaseUrl = "http://$($Server):$($Port)/"
        }

        $LoginSplat = @{
            SessionVariable = "session"
            Body = @{
                action = "AuthenticationManagement"
                method = "login"
                type = "rpc"
                tid = 1
            }
            Uri = $script:ApiBaseUrl + "c/router"
        }

        if ($PSCmdlet.ParameterSetName -eq "Credential") {
            $LoginSplat.Body.data = @( $Credential.UserName, $Credential.GetNetworkCredential().Password, $Remember.ToBool() )
        } else {
            if ($null -ne $Password) {
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)

                $LoginSplat.Body.data = @( $UserName, [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR), $Remember.ToBool() )

                [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
            } else {
                $LoginSplat.Body.data = @( $UserName, $null, $Remember.ToBool() )
            }
        }

        $LoginSplat.Body = $LoginSplat.Body | ConvertTo-Json

        Write-Debug "Trying to login to $($LoginSplat.Uri)"

        try {
            $result = Invoke-NakivoAPI $LoginSplat

            switch ($result.type) {
                "exception" {
                    Write-Error "Login to nakivo failed: $($result.message)"
                }
                "rpc" {
                    switch ($result.data.result) {
                        "OK" {
                            Write-Verbose "Login to nakivo successful"
                            if ($PassThru) {
                                $EndResult = $result.data.userInfo
                                $EndResult.pstypenames.insert(0,"Nakivo.User")
                                Write-Output $EndResult
                            }

                            $script:Multitenancy = $MultiTenancy.ToBool()

                        }
                        "FAIL_OTHER" {
                            Write-Error "Login to nakivo failed: $($result.data.reason). This was your login attempt #$($result.data.canTry.failedAttempts)"
                        }
                        "FAIL_BLOCKED_WAIT" {
                            Write-Error "Login to nakivo failed. You have reached the maximum login attempts ($($result.data.canTry.failedAttempts)) and need to wait $($result.data.canTry.waitTimeLeft) seconds before you can try to login again"
                        }
                        default {
                            Write-Error "Login to nakivo failed: $($result.data.result)"
                        }
                    }
                }
            }


        } catch {
            Write-Error "Unexpected error while connecting to nakivo server: $_"
        }
    }
}
