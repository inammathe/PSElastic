$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Join-ElasticParts Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            # Act
            $result = Join-ElasticParts -Parts ('test','parts') -Separator '/'

            # Assert
            It "Returns the expected type" {
                $result -is [string] | Should -Be $true
            }
            It "Returns the expected value" {
                $result | Should -Be 'test/parts'
            }
        }
    }
}