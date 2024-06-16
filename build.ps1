[CmdletBinding(
    DefaultParameterSetName = "Docs"
)]
param(
    [Parameter(
        ParameterSetName = "Docs"
    )]
    [Switch]$Docs,

    [Parameter(
        ParameterSetName = "Upload"
    )]
    [Switch]$Upload,

    [Parameter(
        ParameterSetName = "Upload",
        Mandatory = $true
    )]
    [Switch]$ApiKey
)

process {
    switch ($PSCmdlet.ParameterSetName) {
        "Docs" {
            Write-Host -ForegroundColor Magenta "Generating docs"

            Import-Module (Join-Path $PSScriptRoot "psNakivo\psNakivo.psd1") -Force

            New-MarkdownHelp -Module psNakivo -OutputFolder .\docs -AlphabeticParamsOrder -UseFullTypeName -WithModulePage -Encoding ([System.Text.Encoding]::UTF8) -Force
        }

        "Upload" {

        }
    }
}
