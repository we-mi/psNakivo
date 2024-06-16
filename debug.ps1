Import-Module (Join-Path $PSScriptRoot "psNakivo\psNakivo.psd1") -Force

$Server = "localhost"
$Username = "admin"
$Password = $null

Connect-Nakivo -Server $Server -Username "admin" -Password $Password -SkipCertificateCheck -PassThru

# do your magic
