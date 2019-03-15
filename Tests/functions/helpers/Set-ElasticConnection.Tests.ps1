$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Set-ElasticConnection Unit Tests" -Tag 'Unit' {
        Context "$ElasticFunction return value validation" {
            # Prepare
            $env:ElasticBaseUrl = $null
            $env:ElasticAuth = $null

            $mockUrl = 'mockUrl'
            $mockUsername = 'mockuser'
            $mockPassword = 'mockpassword'
            $mockCreds = [System.Management.Automation.PSCredential]::new($mockUsername, ($mockPassword | ConvertTo-SecureString -AsPlainText -Force))

            # Act
            $result = Set-ElasticConnection -BaseUrl $mockUrl -Username $mockUsername -Password $mockPassword
            $result_credentials = Set-ElasticConnection -BaseUrl $mockUrl -Credentials $mockCreds

            # Assert
            It "Sets a base url" {
                $result.BaseUrl | Should -Be $mockUrl
                $result_credentials.BaseUrl | Should -Be $mockUrl
            }
            It "Sets an connection header" {
                $result.Header.Authorization | Should -Not -BeNullOrEmpty
                $result.Header.Authorization | Should -BeLike 'Basic*'
                $result_credentials.Header.Authorization | Should -Not -BeNullOrEmpty
                $result_credentials.Header.Authorization | Should -BeLike 'Basic*'
            }
        }
    }
}