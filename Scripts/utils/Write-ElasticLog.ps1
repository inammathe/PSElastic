<#
.SYNOPSIS
    Logging function for PSElastic
.DESCRIPTION
    This utility function is used by all functions within this module to log function calls, errors and invoke requests
.EXAMPLE
    PS C:\> Write-ElasticLog -Message 'test message' -Level 'Info'
    Write the log message '2019-03-04 13:31:19 INFO: test message' to the default logging location ('C:\Logs\PSElastic.log')
#>
function Write-ElasticLog
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path='C:\Logs\PSElastic.log',

        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",

        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        # Set VerbosePreference to Continue so that verbose messages are displayed.
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    Process
    {

        # If the file already exists and NoClobber was specified, do not write to the log.
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path.
        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            New-Item $Path -Force -ItemType File | Out-Null
            }

        else {
            # Nothing to see here yet.
            }

        # Format Date for our Log File
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        # Write message to error, warning, or verbose pipeline and specify $LevelText
        switch ($Level) {
            'Error' {
                $LevelText = 'ERROR:'
                "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
                Write-Error $Message
                }
            'Warn' {
                $LevelText = 'WARNING:'
                Write-Warning $Message
                }
            'Info' {
                $LevelText = 'INFO:'
                Write-Verbose $Message
                }
            }

        # Write log entry to $Path
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
}