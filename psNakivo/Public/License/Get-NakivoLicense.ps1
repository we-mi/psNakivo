<#
.SYNOPSIS
    Retrieve information about the installed nakivo license
.DESCRIPTION
    Retrieve information about the installed nakivo license
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoLicense.md
.EXAMPLE
    Get-NakivoLicense
    Retrieve information about the installed nakivo license
#>
function Get-NakivoLicense {
    [CmdletBinding()]
    [OutputType("Nakivo.License")]
    param ()

    process {

        $LoginSplat = @{
            Body = @{
                action = "LicensingManagement"
                method = "getLicenseInfo"
                type = "rpc"
                tid = 1
                data = $null
            }
            Uri = $script:ApiBaseUrl + "c/router"
        }


        $LoginSplat.Body = $LoginSplat.Body | ConvertTo-Json

        Write-Debug "Trying to get nakivo license"

        try {
            $result = Invoke-NakivoAPI $LoginSplat

            if ($result.data) {

                $EndResults = $result.data

            } else {
                Write-Error "List nakivo license failed: $($result.message)"
            }

        } catch {
            Write-Error "Unexpected error while listing license: $_"
        }

        foreach ($Result in $EndResults) {
            $Result.pstypenames.insert(0,"Nakivo.License")
            Write-Output $Result
        }

    }
}
