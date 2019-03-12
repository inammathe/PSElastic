$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Invoke-ElasticRequest Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            Mock Write-ElasticLog -Verifiable

            Mock Get-ElasticConnection -MockWith {
                $properties = [ordered]@{
                    BaseUrl = 'https://mockBaseUrl:9200'
                    Header = @{'Authorization' = 'mockAuth'}
                }

                return New-Object psobject -Property $properties
            }

            $mockLocation = "$ElasticMockDataLocation\Invoke-ElasticRequest.Mock"
            if (Test-Path $mockLocation) {
                $mockData = Import-CliXML -Path $mockLocation
            }

            Mock Invoke-RestMethod -Verifiable -MockWith {
                return $mockData
            }

            function Test-Function {
                param(
                    [Parameter(Mandatory=$false, ParameterSetName="Query")]
                    [string]
                    $param1,

                    [Parameter(Mandatory=$false, ParameterSetName="Query")]
                    [System.Nullable``1[[System.Int32]]]
                    $param2
                )
                Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Query'
            }
            $variables = Test-Function -param1 'test' -param2 1

            # Act
            $result = Invoke-ElasticRequest -ElasticConnection (Get-ElasticConnection) `
                -Resource 'mock' `
                -QueryVariables $variables `
                -Method 'GET'

            # Assert
            It "Returns a value" {
                $result | Should -not -BeNullOrEmpty
            }
            It "Returns the expected type" {
                $result -is [object] | Should -Be $true
            }
            It "Calls verifiable mocks" {
                Assert-VerifiableMock
            }
            It "Throws on invalid JSON" {
                {
                    Invoke-ElasticRequest -ElasticConnection (Get-ElasticConnection) `
                        -Resource 'mock' `
                        -Content "."
                } | Should -Throw
            }
            It "Continues on valid JSON" {
                {
                    Invoke-ElasticRequest -ElasticConnection (Get-ElasticConnection) `
                        -Resource 'mock' `
                        -Content "{}"
                } | Should -Not -Throw
            }
        }
    }
}