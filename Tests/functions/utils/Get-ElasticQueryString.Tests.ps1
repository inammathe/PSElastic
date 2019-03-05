$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Get-ElasticQueryString Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
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
            $result = Get-ElasticQueryString -QueryVariables $variables

            # Assert
            It "Returns the expected type" {
                $result -is [string] | Should -Be $true
            }
            It "Returns the expected value" {
                $result | Should -Be '?param1=test&param2=1'
            }
        }
    }
}