$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Get-ElasticClusterStats Unit Tests" -Tag 'Unit' {
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

            $mockLocation = "$ElasticMockDataLocation\Get-ElasticClusterStats.Mock"
            if (Test-Path $mockLocation) {
                $mockData = Import-CliXML -Path $mockLocation
            }

            Mock Invoke-ElasticRequest -Verifiable -MockWith {
                return $mockData
            }

            # Act
            $result = Get-ElasticClusterStats
            $result_node_filter = Get-ElasticClusterStats -NodeFilter 'mock_node'

            # Assert
            It "Verifiable mocks are called" {
                Assert-VerifiableMock
            }
            It "Returns a value" {
                $result | Should -not -BeNullOrEmpty
                $result_node_filter | Should -not -BeNullOrEmpty
            }
            It "Returns the expected type" {
                $result -is [object] | Should -Be $true
                $result_node_filter -is [object] | Should -Be $true
            }
        }
    }
}