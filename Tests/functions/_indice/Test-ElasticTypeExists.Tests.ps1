$Global:ElasticModule = 'PSElastic'
$Global:ElasticFunction = ($MyInvocation.MyCommand.Name).Split('.')[0]
$Global:ElasticModuleLocation = (Get-Item (Split-Path -parent $MyInvocation.MyCommand.Path)).parent.parent.parent.FullName
$Global:ElasticMockDataLocation = "$ElasticModuleLocation\Tests\mock_data"

Get-Module $ElasticModule | Remove-Module
Import-Module "$ElasticModuleLocation\$ElasticModule.psd1"

InModuleScope $ElasticModule {
    Describe "Test-ElasticTypeExists Unit Tests" -Tag 'Unit' {
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

            Mock Invoke-ElasticRequest -Verifiable -MockWith {
                return $null
            }

            # Act
            $result_success = Test-ElasticTypeExists -Name 'mockIndex' -Type 'mockPass'

            # Assert
            It "Verifiable mocks are called" {
                Assert-VerifiableMock
            }
            It "Returns a value" {
                $result_success | Should -not -BeNullOrEmpty
            }
            It "Returns the expected value" {
                $result_success | Should -Be $true
            }
            It "Calls Write-ElasticLog and is only invoked once" {
                Assert-MockCalled -CommandName Write-ElasticLog -Times 1 -Exactly
            }
            It "Calls Get-ElasticConnection and is only invoked once" {
                Assert-MockCalled -CommandName Get-ElasticConnection -Times 1 -Exactly
            }
            It "Calls Invoke-ElasticRequest and is only invoked once" {
                Assert-MockCalled -CommandName Invoke-ElasticRequest -Times 1 -Exactly
            }
        }
    }
}