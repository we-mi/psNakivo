<#
.SYNOPSIS
    Get jobs for a nakivo tenant
.DESCRIPTION
    Get jobs for a nakivo tenant. You can pipe the output of "Get-NakivoTenant" to this command.
.LINK
    https://github.com/we-mi/psNakivo/blob/main/docs/Get-NakivoJob.md
.PARAMETER TenantName
    The name of the tenant you want to list the jobs for
.PARAMETER TenantUUID
    The UUID of the tenant you want to list the jobs for
.EXAMPLE
    Get-NakivoJob -TenantName "Mordor"
    List all available Nakivo jobs for the tenant "Mordor" (hey, Sauron needs backups too, you know?)
.EXAMPLE
    Get-NakivoTenant "Mordor" | Get-NakivoJob
    Same as example above but with pipelines
.EXAMPLE
    Get-NakivoTenant "Mordor","Gondor" | Get-NakivoJob
    You can also pipe multiple Tenants to this command
#>
function Get-NakivoJob {
    [CmdletBinding(DefaultParameterSetName="UUID")]
    [OutputType("Nakivo.Job")]
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

        # because the nakivo api is a piece of !$%&! (at least what is documented) we cant just get a list of all jobs but instead need to get the job overview for the tenant and get the list of jobs from there
        $tenantJobs = Get-NakivoJobOverview -TenantUUID $TenantUUID | Select-Object -ExpandProperty childJobIds

        if ($null -eq $tenantJobs) {
            return $null
        }

        $LoginSplat = @{
            Body = @{
                action = "JobSummaryManagement"
                method = "getJobInfo"
                type = "rpc"
                tid = 1
                data = @( @($tenantJobs), 0, $true)
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

        Write-Debug "Trying to get nakivo jobs for tenant $TenantUUID"

        try {
            $result = Invoke-NakivoAPI $LoginSplat | ConvertFrom-Json

            if ($result.data) {

                    $EndResults = $result.data.children

            } else {
                Write-Error "List nakivo jobs for tenant $TenantUUID failed: $($result.message)"
            }

        } catch {
            Write-Error "Unexpected error while listing jobs for tenant $TenantUUID : $_"
        }

        foreach ($Result in $EndResults) {
            $Result.pstypenames.insert(0,"Nakivo.Job")
            Write-Output $Result
        }

    }
}
