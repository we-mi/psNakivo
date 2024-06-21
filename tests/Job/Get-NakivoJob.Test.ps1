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

Describe "Get-NakivoJob" {

    BeforeEach {
        Import-Module (Join-Path $PSScriptRoot "..\..\psNakivo\psNakivo.psd1") -Force

        Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -MultiTenancy| Out-Null
    }

    It "Should return a valid object" {
        {
            Get-NakivoTenant | Get-NakivoJob
        } | Should -Not -Throw
    }

    # Does not work right now because we do not have any jobs in the demo instance
    <# It "Should return an object of type 'Nakivo.Job'" {
        (Get-NakivoTenant | Get-NakivoJob)[0].pstypenames[0] | Should -Be "Nakivo.Job"
    } #>

}
