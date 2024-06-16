[CmdletBinding()]
param()

process {
    Write-Host -ForegroundColor Magenta "Generating docs"

    Get-Module psNakivo | Remove-Module
    Import-Module (Join-Path $PSScriptRoot "psNakivo\psNakivo.psd1")

    Update-MarkdownHelp .\docs -AlphabeticParamsOrder -UseFullTypeName -Encoding ([System.Text.Encoding]::UTF8)
}
