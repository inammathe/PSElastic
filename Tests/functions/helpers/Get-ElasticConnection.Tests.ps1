$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Get-ElasticConnection Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            $env:ElasticBaseUrl = 'mockUrl'
            $env:ElasticAuth = 'mockAuth'

            # Act
            $result = Get-ElasticConnection

            # Assert
            It "Returns a base url" {
                $result.BaseUrl | Should -Be 'mockUrl'
            }
            It "Returns a connection header" {
                $result.Header.Authorization | Should -Be 'mockAuth'
            }
            It "Throws when ElasticBaseUrl is not set" {
                {
                    $env:ElasticBaseUrl = $null
                    $env:ElasticAuth = 'mockAuth'
                    Get-ElasticConnection
                } | Should -Throw
            }
            It "Throws when ElasticAuth is not set" {
                {
                    $env:ElasticBaseUrl = 'mockUrl'
                    $env:ElasticAuth = $null
                    Get-ElasticConnection
                } | Should -Throw
            }
            It "Throws when ElasticAuth and ElasticBaseUrl is not set" {
                {
                    $env:ElasticBaseUrl = $null
                    $env:ElasticAuth = $null
                    Get-ElasticConnection
                } | Should -Throw
            }
        }
    }
}
