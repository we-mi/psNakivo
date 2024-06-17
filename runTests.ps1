Get-ChildItem -Path (Join-Path $PSScriptRoot 'tests') -Recurse -Filter "*.Test.ps1" | ForEach-Object {
    Invoke-Pester -Output Detailed -Path $_.FullName
}
