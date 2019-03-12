$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "New-ElasticIndex Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            Mock Write-ElasticLog -Verifiable -MockWith {}

            Mock Get-ElasticConnection -MockWith {
                $properties = [ordered]@{
                    BaseUrl = 'https://mockBaseUrl:9200'
                    Header = @{'Authorization' = 'mockAuth'}
                }

                return New-Object psobject -Property $properties
            }

            $mockData = Import-CliXML -Path "$ElasticMockDataLocation\New-ElasticIndex.Mock"
            Mock Invoke-ElasticRequest -Verifiable -MockWith {
                return $mockData
            }

            # Act
            $result = New-ElasticIndex -Name 'mock' -number_of_shards 1 -number_of_replicas 0

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
            It "Correctly Validates the index name" {
                # Must be Lowercase
                { New-ElasticIndex -Name 'Mock' } | Should -Throw

                # Must not contain illegal characters
                foreach ($illegalCharacterName in @('\', '/', '*', '?', '"', '<', '>', '|', ' ', ',', '#', ':')) {
                    { New-ElasticIndex -Name $illegalCharacterName } | Should -Throw
                }

                # Must not start with illegal characters
                foreach ($illegalCharacterName in @('-mock', '_mock', '+mock')) {
                    { New-ElasticIndex -Name $illegalCharacterName } | Should -Throw
                }

                # Cannot be . or ..
                { New-ElasticIndex -Name '.' } | Should -Throw
                { New-ElasticIndex -Name '..' } | Should -Throw

                # Cannot be longer than 255 bytes
                { New-ElasticIndex -Name ('m'*256) } | Should -Throw
            }
        }
    }
}