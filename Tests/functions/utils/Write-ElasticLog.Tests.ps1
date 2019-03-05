$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Write-ElasticLog Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            Mock Out-File -Verifiable -MockWith {
                $_ | Write-Output
            }

            # Act
            $result = Write-ElasticLog -Message 'test message' -Level 'Info'

            # Assert
            It "Returns the expected type" {
                $result -is [string] | Should -Be $true
            }
            It "Returns the expected value" {
                $result | Should -Match 'INFO: test message'
            }
            It "Throws on error" {
                { Write-ElasticLog -Message 'test message' -Level 'Error' -ErrorAction Stop } | Should -Throw
            }
            It "Calls Out-File and is invoked twice" {
                Assert-MockCalled -CommandName Out-File -Times 2 -Exactly
            }
        }
    }
}