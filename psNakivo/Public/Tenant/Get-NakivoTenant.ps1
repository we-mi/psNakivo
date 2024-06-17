<#
.SYNOPSIS
    List nakivo tenants
.DESCRIPTION
    List nakivo tenants. Use the 'TenantName'-Parameter to filter the output
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoTenant.md
.PARAMETER TenantName
    One or more Tenant Names to filter for. Can contain wildcards
.EXAMPLE
    Get-NakivoTenant
    List all available Nakivo tenants
.EXAMPLE
    Get-NakivoTenant -TenantName "Customer1*"
    List all available Nakivo tenants which names begins with `Customer1`
.EXAMPLE
    Get-NakivoTenant "Test*","Dummy"
    List all available Nakivo tenants which names contains `Test` or are named `Dummy`
#>
function Get-NakivoTenant {
    [CmdletBinding()]
    [OutputType("Nakivo.Tenant")]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0
        )]
        [String[]] $TenantName
    )

    process {

        $LoginSplat = @{
            Body = @{
                action = "MultitenancyManagement"
                method = "getTenants"
                type = "rpc"
                tid = 1
                data = $null
            }
            Uri = $script:ApiBaseUrl + "c/router"
        }


        $LoginSplat.Body = $LoginSplat.Body | ConvertTo-Json

        Write-Debug "Trying to get nakivo tenants"

        try {
            $result = Invoke-NakivoAPI $LoginSplat | ConvertFrom-Json

            if ($result.data) {
                if ($TenantName) {

                    $EndResults = @()

                    foreach ($filter in $TenantName) {
                        $EndResults += $result.data.children | Where-Object { $_.name -like $filter }
                    }
                } else {
                    $EndResults = $result.data.children
                }
            } else {
                Write-Error "List nakivo tenants failed: $($result.message)"
            }

        } catch {
            Write-Error "Unexpected error while listing tenants: $_"
        }

        foreach ($Result in $EndResults) {
            $Result.pstypenames.insert(0,"Nakivo.Tenant")
            Write-Output $Result
        }

    }
}
