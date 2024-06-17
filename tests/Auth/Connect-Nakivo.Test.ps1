Describe "Connect-Nakivo" {

    BeforeEach {
        $script:Server = "localhost"
        $script:Username = "admin"
        $script:Password = $null

        $ModulePath = "$PSScriptRoot\..\..\psNakivo\"

        Import-Module (Join-Path $ModulePath "psNakivo.psd1") -Force
    }

    Context "Username and Password Login" {

        It "Should login" {
            {
                Connect-Nakivo -Server $script:Server -Username $script:Username -Password $script:Password -SkipCertificateCheck
            } | Should -Not -Throw
        }

        It "Should give back an object containing your own username" {
            (Connect-Nakivo -Server $script:Server -Username $script:Username -Password $script:Password -SkipCertificateCheck -PassThru).name | Should -Be $script:Username
        }

    }

}
