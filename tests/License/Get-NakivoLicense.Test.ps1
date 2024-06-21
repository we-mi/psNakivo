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

Describe "Get-NakivoLicense" {

    BeforeEach {
        $ModulePath = "$PSScriptRoot\..\..\psNakivo\"

        Import-Module (Join-Path $ModulePath "psNakivo.psd1") -Force
    }

    It "Should return a valid object" {
        {
            Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck | Out-Null
            Get-NakivoLicense
        } | Should -Not -Throw
    }

    It "Should return an object of type 'Nakivo.License'" {
        Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -PassThru | Out-Null
        (Get-NakivoLicense).PSObject.TypeNames | Should -Contain "Nakivo.License"
    }

}
