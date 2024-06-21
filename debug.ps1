Import-Module (Join-Path $PSScriptRoot "psNakivo\psNakivo.psd1") -Force

$Server = "localhost"
$Username = "admin"
$Password = $null

Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -PassThru -MultiTenancy

# do your magic

Disconnect-Nakivo
