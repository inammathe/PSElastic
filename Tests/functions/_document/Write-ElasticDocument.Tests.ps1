$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Write-ElasticDocument Unit Tests" -Tag 'Unit' {
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

            $mockData = Import-CliXML -Path "$ElasticMockDataLocation\Write-ElasticDocument.Mock"
            Mock Invoke-ElasticRequest -Verifiable -MockWith {
                return $mockData
            }

            $json = [PSCustomObject]@{
                timestamp = (Get-Date (Get-Date).AddHours(-10) -f 'yyyyMMddHHmmss')
                message = 'Mock Insert'
            } | ConvertTo-Json

            # Act
            $result = Write-ElasticDocument -Name 'mock' -JSON $json

            # Assert
            It "Verifiable mocks are called" {
                Assert-VerifiableMock
            }
            It "Returns a value" {
                $result | Should -not -BeNullOrEmpty
            }
            It "Validates JSON correctly" {
                { Write-ElasticDocument -Name 'mock' -JSON ($json += 'bad_json') } | Should -Throw
            }
            It "Returns the expected value" {
                $result._index | Should -Be 'mock'
            }
            It "Returns the expected type" {
                $result -is [object] | Should -Be $true
            }
            It "Calls Get-ElasticConnection and is invoked twice" {
                Assert-MockCalled -CommandName Get-ElasticConnection -Times 2 -Exactly
            }
        }
    }
}