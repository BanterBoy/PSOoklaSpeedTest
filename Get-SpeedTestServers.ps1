function Get-SpeedTestServerList {
    <#
		.SYNOPSIS
			The Get-SpeedTestServerList function is a wrapper for the the official command line client from Speedtest by Ookla for testing the speed and performance of your internet connection.
			
				Usage:
				-L, --servers                     List nearest servers
				-s, --server-id=#                 Specify a server from the server list using its id
				-I, --interface=ARG               Attempt to bind to the specified interface when connecting to servers
				-i, --ip=ARG                      Attempt to bind to the specified IP address when connecting to servers
				-o, --host=ARG                    Specify a server, from the server list, using its host's fully qualified domain name

        .DESCRIPTION
			A detailed description of the Get-SpeedTestServers function.
		
		.EXAMPLE
			Get-SpeedTestServers

		
		.NOTES
			Additional information about the function.
	#>
    BEGIN {
    }
    PROCESS {
        $Speedtest = & $PSScriptRoot\speedtest.exe --format=json-pretty --accept-license --accept-gdpr --servers
        $Speedtest = ($Speedtest | ConvertFrom-Json).Servers
        foreach ($Server in $Speedtest) {
            Try {
                $properties = [ordered]@{
                    Name     = $Server.name
                    Host     = $Server.host
                    Id       = $Server.id
                    Port     = $Server.port
                    Location = $Server.location
                    Country  = $Server.country
                }
            }
            Catch {
                Write-Error $_
            }
            Finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }
    END {
    }
}
