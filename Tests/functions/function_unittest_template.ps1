$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "FunctionName Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            Mock Write-ElasticLog -Verifiable -MockWith {} -ParameterFilter {$message -eq $ElasticFunction}

            Mock Get-ElasticConnection -MockWith {
                $properties = [ordered]@{
                    BaseUrl = 'https://mockBaseUrl:9200'
                    Header = @{'Authorization' = 'mockAuth'}
                }

                return New-Object psobject -Property $properties
            }

            # Act
            $result = Get-ElasticCluster

            # Assert
            It "Verifiable mocks are called" {
                Assert-VerifiableMock
            }
            It "Returns a value" {
                $result | Should -not -BeNullOrEmpty
            }
            It "Returns the expected type" {
                $result -is [object] | Should -Be $true
            }
            It "Calls Get-ElasticConnection and is only invoked once" {
                Assert-MockCalled -CommandName Get-ElasticConnection -Times 1 -Exactly
            }
        }
    }
}