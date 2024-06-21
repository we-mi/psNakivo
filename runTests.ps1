[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [String]$Server,

    [Parameter(Mandatory)]
    [String]$Username,

    [Parameter(Mandatory)]
    [AllowEmptyString()]
    [String]$Password
)

if ( [String]::IsNullOrWhiteSpace($Password) ) {
    $pwObject = $null
} else {
    $pwObject = $Password | ConvertTo-SecureString -AsPlainText -Force
}

Get-ChildItem -Path (Join-Path $PSScriptRoot 'tests') -Recurse -Filter "*.Test.ps1" | ForEach-Object {
    $pesterContainer = New-PesterContainer -Path $_.Fullname -Data @{
        Server = $Server
        Username = $Username
        Password = $pwObject
    }

    $pesterConfig = New-PesterConfiguration
    $pesterConfig.Output.Verbosity = "Detailed"
    $pesterConfig.Run.PassThru = $False
    $pesterConfig.Run.Container = $pesterContainer

    Invoke-Pester -Configuration $pesterConfig
}
