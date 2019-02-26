@{
    # If authoring a script module, the RootModule is the name of your .psm1 file
    RootModule = 'PSElastic.psm1'

    Author = 'Evan Lock <inammathe@gmail.com>'

    CompanyName = 'Contoso'

    ModuleVersion = '1.0'

    # Use the New-Guid command to generate a GUID, and copy/paste into the next line
    GUID = '423948d9-f46f-43a3-a9d8-32881f20f232'

    Copyright = ''

    Description = 'This is a collection of useful functions to manage Elastic'

    # Minimum PowerShell version supported by this module (optional, recommended)
    PowerShellVersion = '5.0'

    # Which PowerShell aliases are exported from your module? (eg. gco)
    #AliasesToExport = @('')

    # Which PowerShell variables are exported from your module? (eg. Fruits, Vegetables)
    #VariablesToExport = @('')
    # Functions to export from this module
    FunctionsToExport = '*'

    # PowerShell Gallery: Define your module's metadata
    PrivateData = @{
        PSData = @{
            # What keywords represent your PowerShell module? (eg. cloud, tools, framework, vendor)
            Tags = @('Elastic', 'API')

            # What software license is your code being released under? (see https://opensource.org/licenses)
            LicenseUri = ''

            # What is the URL to your project's website?
            ProjectUri = 'https://github.com/inammathe/PSElastic'

            # What is the URI to a custom icon file for your project? (optional)
            IconUri = ''

            # What new features, bug fixes, or deprecated features, are part of this release?
            ReleaseNotes = @'
'@
        }
    }
    #>
    # If your module supports updateable help, what is the URI to the help archive? (optional)
    # HelpInfoURI = ''
}