$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Test-ElasticJson Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            # Act
            $result1 = Test-ElasticJson -JSON '{good_json:{}}'
            $result2 = Test-ElasticJson -JSON 'bad_json'

            # Assert
            It "Returns a value" {
                $result1 | Should -Not -BeNullOrEmpty
                $result2 | Should -Not -BeNullOrEmpty
            }
            It "Returns the expected type and value" {
                $result1 | Should -Be $true
                $result2 | Should -Be $false
            }
        }
    }
}