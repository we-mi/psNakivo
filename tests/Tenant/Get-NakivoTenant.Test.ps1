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

Describe "Get-NakivoTenant" {

    BeforeEach {
        Import-Module (Join-Path $PSScriptRoot "..\..\psNakivo\psNakivo.psd1") -Force

        Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -MultiTenancy| Out-Null
    }

    It "Should return a valid object" {
        {
            Get-NakivoTenant
        } | Should -Not -Throw
    }

    It "Should return an object of type 'Nakivo.Tenant'" {
        (Get-NakivoTenant | Select-Object -First 1).PSObject.TypeNames | Should -Contain "Nakivo.Tenant"
    }

}
