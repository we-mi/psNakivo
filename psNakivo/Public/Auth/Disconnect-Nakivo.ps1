<#
.SYNOPSIS
    Disconnect from a nakivo instance (logout)
.DESCRIPTION
    Disconnect from a nakivo instance
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Disconnect-Nakivo.md
.EXAMPLE
    Disconnect-Nakivo
#>
function Disconnect-Nakivo {
    [CmdletBinding()]
    [OutputType($null)]
    param ()

    process {
        $WebSplat = @{
            Body = @{
                action = "AuthenticationManagement"
                method = "logoutCurrentUser"
                type = "rpc"
                tid = 1
            } | ConvertTo-Json
            Uri = $script:ApiBaseUrl + "c/router"
        }

        Write-Debug "Trying to logout from $($WebSplat.Uri)"

        try {
            $result = Invoke-NakivoAPI $WebSplat

            if ($null -ne $result.message) {
                Write-Error "Disconnect from nakivo server failed: $($result.message)"
            }
        } catch {
            Write-Error "Unexpected error while connecting to nakivo server: $_"
        }

        @(  "SkipCertificateCheck"
            "ApiBaseUrl"
            "Multitenancy"
            "WebSession" ) | ForEach-Object {
                Remove-Variable -Scope Script -Name $_ -Force
        }
    }
}
