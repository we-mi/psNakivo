<#
.SYNOPSIS
    Get job overview for a nakivo tenant
.DESCRIPTION
    Get job overview for a nakivo tenant. You can pipe the output of "Get-NakivoTenant" to this command.
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoJob.md
.PARAMETER TenantName
    The name of the tenant you want to list the job overview for
.PARAMETER TenantUUID
    The UUID of the tenant you want to list the job overview for
.EXAMPLE
    Get-NakivoJobOverview -TenantName "Mordor"
    List the job overview for the tenant "Mordor" (hey, Sauron needs backups too, you know?)
.EXAMPLE
    Get-NakivoTenant "Mordor" | Get-NakivoJobOverview
    Same as example above but with pipelines
.EXAMPLE
    Get-NakivoTenant "Mordor","Gondor" | Get-NakivoJobOverview
    You can also pipe multiple Tenants to this command
#>
function Get-NakivoJobOverview {
    [CmdletBinding(DefaultParameterSetName="UUID")]
    [OutputType("Nakivo.JobOverview")]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "Name"
        )]
        [String] $TenantName,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline,
            ParameterSetName = "UUID"
        )]
        [Alias("UUID")]
        [String] $TenantUUID
    )

    process {

        if ($PSCmdlet.ParameterSetName -eq "Name") {
            $TenantUUID = Get-NakivoTenant -TenantName $TenantName | Select-Object -ExpandProperty "UUID"
        }

        $LoginSplat = @{
            Body = @{
                action = "JobSummaryManagement"
                method = "getGroupInfo"
                type = "rpc"
                tid = 1
                data = @(@($null), 0, $true)
            }
            Uri = $(
                if ($script:Multitenancy) {
                    $script:ApiBaseUrl + "t/$TenantUUID/c/router"
                } else {
                    $script:ApiBaseUrl + "c/router"
                }
            )
        }

        $LoginSplat.Body = $LoginSplat.Body | ConvertTo-Json

        Write-Debug "Trying to get nakivo job overview for tenant $TenantUUID"

        try {
            $result = Invoke-NakivoAPI $LoginSplat

            if ($result.data) {

                    $EndResults = $result.data.children

            } else {
                Write-Error "List nakivo job overview for tenant $TenantUUID failed: $($result.message)"
            }

        } catch {
            Write-Error "Unexpected error while listing job overview for tenant $TenantUUID : $_"
        }

        foreach ($Result in $EndResults) {
            $Result.pstypenames.insert(0,"Nakivo.JobOverview")
            Write-Output $Result
        }
    }
}
