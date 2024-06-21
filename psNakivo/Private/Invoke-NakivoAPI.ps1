function Invoke-NakivoAPI {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Hashtable]
        $Request
    )

    begin {
        $Request.Method = "Post"
        $Request.Headers = @{
            "Content-Type" = "application/json"
        }
        $Request.ErrorAction = "Stop"
        $Request.SkipCertificateCheck = $script:SkipCertificateCheck

        if ($PSVersionTable.PSVersion.Major -lt 6) {
            add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
            if ($Request.SkipCertificateCheck) {
                [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            }

            # PS5 implementation of Invoke-WebRequest does not support "SkipCertificateCheck" parameter
            $Request.Remove("SkipCertificateCheck")
        }

    }

    process {

        # special case for registering the admin user on the first startup: no need for cookies
        $BodyAsJson = $Request.Body | ConvertFrom-Json
        if ( $BodyAsJson.action -ne "RegistrationManagement" -and $BodyAsJson.method -ne "register") {
            if ( $Request.ContainsKey("SessionVariable") ) {
                # This seems to be a login request
                $Request.Remove("WebSession") # Just to be sure
            } else {
                # This seems to be a 'normal' request session, which needs to have the "WebSession" parameter for Invoke-Webrequest
                if ( $null -eq $script:WebSession ) {
                    Throw "You do not seem to be connected to a nakivo instance right now. Please use 'Connect-Nakivo' command before using any other command"
                } else {
                    $Request.WebSession = $script:WebSession
                }

            }
        }

        $ProgressPreference = "SilentlyContinue"
        $result = Invoke-WebRequest @Request

        if ($Request.ContainsKey("SessionVariable")) {
            $script:WebSession = Get-Variable -Name $Request.SessionVariable -Scope Local | Select-Object -ExpandProperty Value
        }

        try {
            $result.Content | ConvertFrom-Json
        } catch {
            $result.Content
        }
    }
}
