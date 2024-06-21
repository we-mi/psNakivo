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

Describe "Connect-Nakivo" {

    BeforeEach {
        $ModulePath = "$PSScriptRoot\..\..\psNakivo\"

        Import-Module (Join-Path $ModulePath "psNakivo.psd1") -Force
    }

    Context "Username and Password Login" {

        It "Should not throw an error" {
            {
                Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck
            } | Should -Not -Throw
        }

        It "Should return an object of type 'Nakivo.User'" {
            (Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -PassThru).PSObject.TypeNames | Should -Contain "Nakivo.User"
        }

        It "Should give back an object containing your own username" {
            (Connect-Nakivo -Server $Server -Username $Username -Password $Password -SkipCertificateCheck -PassThru).name | Should -Be $Username
        }

    }

}
