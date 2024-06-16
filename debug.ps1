Import-Module (Join-Path $PSScriptRoot "psNakivo\psNakivo.psd1") -Force

$Server = "localhost"
$Username = "admin"
$Password = "nakivo" | ConvertTo-SecureString -AsPlainText -Force

$Credential = New-Object pscredential -ArgumentList $Username, $Password

Connect-Nakivo -Server $Server -Credential $Credential -SkipCertificateCheck

# do your magic
