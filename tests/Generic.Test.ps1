AfterAll {
    Remove-Module "psNakivo"
}

Describe "<_>" -Tags "Help" -ForEach $(Import-Module (Join-Path $PSScriptRoot "\..\psNakivo\psNakivo.psd1") -Force; Get-Command -Module "psNakivo" | Where-Object { $_.CommandType -ne 'Alias' } ) {

    Context "Function Help" {

        It 'Synopsis not empty' {
            Get-Help $_ | Select-Object -ExpandProperty synopsis | Should -Not -BeNullOrEmpty
        }

        It "Synopsis should not be auto-generated" {
            Get-Help $_ | Select-Object -ExpandProperty synopsis | Should -Not -BeLike '*`[`<CommonParameters`>`]*'
        }

        It 'Description not empty' {
            Get-Help $_ | Select-Object -ExpandProperty Description | Should -Not -BeNullOrEmpty
        }

        It 'Examples Count greater than 0' {
            $Examples = Get-Help $_ | Select-Object -ExpandProperty Examples | Measure-Object
            $Examples.Count -gt 0 | Should -Be $true
        }

    }

    Context "PlatyPS Default Help" {
        It "Synopsis should not be auto-generated - Platyps default"  {
            Get-Help $_ | Select-Object -ExpandProperty synopsis | Should -Not -BeLike '*{{Fill in the Synopsis}}*'
        }

        It "Description should not be auto-generated - Platyps default" {
            Get-Help $_ | Select-Object -ExpandProperty Description | Should -Not -BeLike '*{{Fill in the Description}}*'
        }

        It "Example should not be auto-generated - Platyps default" {
            Get-Help $_ | Select-Object -ExpandProperty Examples | Should -Not -BeLike '*{{ Add example code here }}*'
        }
    }

    Context "Parameter Help" {

        It "Parameter Help for '<_.name>'" -ForEach (Get-Help $_ | Select-Object -ExpandProperty Parameters).parameter {
            $_.description.text | Should -Not -BeNullOrEmpty
        }

    }

    # Output Type if Verb is 'Get'
    Context "OutputType - $($_.Name)" -Skip:$($_.Verb -ne "Get") {

        It "OutputType Present on verb Get" {
            (Get-Command $_).OutputType | Should -Not -BeNullOrEmpty
        }

    }

}

Describe 'Module Information' -Tags 'Command'{
    BeforeEach {
        $ModuleManifest = (Join-Path (Get-Module "psNakivo" | Select-Object -ExpandProperty ModuleBase) "psNakivo.psd1")
    }

    Context 'Manifest Testing' {

        It 'Valid Module Manifest' {
            {
                $Script:Manifest = Test-ModuleManifest -Path $ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should -Not -Throw
        }

        It 'Test-ModuleManifest' {
          Test-ModuleManifest -Path $ModuleManifest
          $? | Should -Be $true
        }

        It 'Valid Manifest Name' {
            $Script:Manifest.Name | Should -Be "psNakivo"
        }

        It 'Generic Version Check' {
            $Script:Manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
        }

        It 'Valid Manifest Description' {
            $Script:Manifest.Description | Should -Not -BeNullOrEmpty
        }

        It 'Valid Manifest Root Module' {
            $Script:Manifest.RootModule | Should -Be ".\psNakivo.psm1"
        }

        It 'Valid Manifest GUID' {
            ($Script:Manifest.guid).gettype().name | Should -Be 'Guid'
        }

        It 'Has Format File' {
            $Script:Manifest.ExportedFormatFiles | Should -Not -BeNullOrEmpty
        }

        It 'Format File Exists' {
            Test-Path -PathType Leaf $Script:Manifest.ExportedFormatFiles | Should -Be $True
        }

        It 'Valid Format File' {
            {
                [xml](Get-Content $Script:Manifest.ExportedFormatFiles -Encoding UTF8)
            } | Should -Not -Throw
        }

        It 'Required Modules' {
            $Script:Manifest.RequiredModules | Should -BeNullOrEmpty
        }
    }

    Context 'Exported Functions' {
        It 'Proper Number of Functions Exported' {
            $ExportedCount = Get-Command -Module "psNakivo" | Where-Object { $_.CommandType -ne 'Alias' } | Measure-Object | Select-Object -ExpandProperty Count
            $FileCount = Get-ChildItem -Path (Join-Path (Get-Module "psNakivo" | Select-Object -ExpandProperty ModuleBase) "Public") -Filter *.ps1 -Recurse | Measure-Object | Select-Object -ExpandProperty Count

            $ExportedCount | Should -Be $FileCount
        }
    }

}

