$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Get-ParamSetVariables Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            function Test-Function {
                param (
                    [Parameter(Mandatory=$false, ParameterSetName="Params")]
                    [string]
                    $param1,

                    [Parameter(Mandatory=$false, ParameterSetName="Params")]
                    [System.Nullable``1[[System.Int32]]]
                    $param2,

                    [Parameter(Mandatory=$false, ParameterSetName="Params")]
                    [switch]
                    $param3
                )
                Get-ParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Params'
            }

            # Act
            $result1 = Test-Function
            $result2 = Test-Function -param1 'test' -param2 1 -param3

            # Assert
            It "No params does not return a value" {
                $result1 | Should -BeNullOrEmpty
            }
            It "Params return a value" {
                $result2 | Should -Not -BeNullOrEmpty
            }
            It "Returns the expected type" {
                $result2 -is [object] | Should -Be $true
            }
            It "Returns the expected members" {
                $result2.param1 -is [string] | Should -Be $true
                $result2.param1 | Should -Be 'test'
                $result2.param2 -is [int] | Should -Be $true
                $result2.param2 | Should -Be 1
                $result2.param3.IsPresent -is [bool] | Should -Be $true
                $result2.param3 | Should -Be $true
            }
        }
    }
}