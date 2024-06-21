[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [String]$Server,

    [Parameter(Mandatory)]
    [String]$Username,

    [Parameter(Mandatory)]
    [AllowNull()]
    [securestring]$Password
)

Describe "Disconnect-Nakivo" {

    BeforeEach {
        Import-Module (Join-Path $PSScriptRoot "..\..\psNakivo\psNakivo.psd1") -Force

        Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -MultiTenancy| Out-Null
    }

    It "Should not throw an error" {
        {
            Disconnect-Nakivo
        } | Should -Not -Throw
    }

    It "Should not return any object" {
        (Disconnect-Nakivo) | Should -Be $null
    }

    It "Should not let you use another nakivo command after logging out" {
        Disconnect-Nakivo
        {
            Get-NakivoLicense -ErrorAction Stop
        } | Should -Throw -ExpectedMessage '*You do not seem to be connected to a nakivo instance right now*'
    }



}
