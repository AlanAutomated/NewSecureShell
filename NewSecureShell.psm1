# This module is a simple wrapper comprisd of a single function
function New-SecureShell {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$SessionHost
    )
    # This is the default path to the OpenSSH client on Windows 10
    Return Start-Process -FilPath C:\Windows\System32\OpenSSH\ssh.exe $SessionHost
}

$ScriptBlock = {
    $ConfigHosts = @(
        (
            # A valid DNS hostname is expected
            Get-Content -Path ~/.ssh/config | Select-String -Pattern '^Host [a-z0-9\-\.]+$'
        ).Matches.ForEach(
            {
                $_.Value.split()[1]
            }
        )
    )
    # Only return if there are actual hosts
    if ($ConfigHosts.Count) {
        $ConfigHosts
    }
}

# Register the parameters for auto completion
Register-ArgumentCompleter -CommandName New-SecureShell -ParameterName SessionHost -ScriptBlock $ScriptBlock

# Finally, export the function
Export-ModuleMember -Function New-SecureShell