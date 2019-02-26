# PSElastic
[![Build status](https://ci.appveyor.com/api/projects/status/q8xh0pndvsba0kpd?svg=true)](https://ci.appveyor.com/project/inammathe/pselastic/branch/master)

This is a PowerShell module that exports a bunch of handy functions which can be used to manage various aspects of Elastic.
At the moment these functions are mostly just wrappers for the Elastic rest API.

Installation
======

## Using PowerShell Gallery:
If you have [WMF 5.0](https://www.microsoft.com/en-us/download/details.aspx?id=50395) or [PowerShellGet ](https://docs.microsoft.com/en-us/powershell/gallery/readme) installed:

```
#Inspect
PS> Save-Module -Name pselastic -Path <path>
```
```
#Install
PS> Install-Module -Name pselastic
```

https://www.powershellgallery.com/packages/pselastic/


## Manually:
1. Clone or download this repo https://github.com/inammathe/PSElastic
2. `Import-Module .\PSElastic\PSElastic.psd1`.

PSElastic.psm1 has a handful of utility functions and will load all the scripts in the `.\Scripts` directory upon importing the module.

Example Use
======
```
Import-Module '.\PSElastic.psd1'

# Set Connection information - Highly recommend you add the environment vars to your $profile to save you having to do it every time.
Set-ElasticConnection -URL 'https://MyPSElastic.com:9300' -Username 'user' -Password 'pass'

# Get the health of your cluster
Get-ElasticClusterHealth
```

How to Contribute
======
1. Fork this repo
2. Make your changes
3. Create a pull request

CI/CD Pipeline
======
Adapted from http://ramblingcookiemonster.github.io/PSDeploy-Inception/#appveyor-and-powershell-gallery
## Scaffolding
* AppVeyor.yml. Instructions for AppVeyor.
* Start-Build.ps1. A build script that sets up dependencies and kicks off psake. Portable across build systems. This initialises the following:
    * BuildHelpers. A module to help with portability and some common build needs
    * Psake. A build automation tool. This Defines a series of tasks for our build
    * Pester. A testing framework for PowerShell
    * PSDeploy. A module to simplify PowerShell based deployments - Modules, in this case
* Psake.ps1. Tasks to run - testing, build (e.g. bump version number), and deployment to the PowerShell gallery
* deploy.psdeploy.ps1. Instructions that tell PSDeploy how to deploy the module

## Process
1. GitHub sends AppVeyor a notification of your commit
2. AppVeyor parses your appveyor.yml and starts a build on a fresh VM
3. build.ps1 installs dependencies, sets up environment variables with BuildHelpers, and kicks off psake.ps1
4. psake.ps1 does the real work. It runs your Pester tests, and if they pass, runs PSDeploy against your psdeploy.ps1
