# This module is a simple wrapper comprisd of a single function
function New-SecureShell {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$SessionHost
    )
    # This is the default path to the OpenSSH client on Windows 10
    if ($SessionHost) { 
        return Start-Process -FilePath C:\Windows\System32\OpenSSH\ssh.exe $SessionHost
    }
    return "You must specify a hostname or IP address"
}

$ScriptBlock = {
    param ($commandName, $parameterName, $wordToComplete)
    $ConfigHosts = @(
        (
            # A valid DNS hostname is expected
            Get-Content -Path ~/.ssh/config | Select-String -Pattern '^Host [a-z0-9\-\.\:]+$'
        ).Matches.ForEach(
            {
                $_.Value.split()[1] 
            }
        )
    )
    # Only return matches, if any
    if ($ConfigHosts.Count) {
        $ConfigHosts | Where-Object { $_ -Like "$wordToComplete*" }
    }
}

# Register the parameters for auto completion
Register-ArgumentCompleter -CommandName New-SecureShell -ParameterName SessionHost -ScriptBlock $ScriptBlock

New-Alias -Name ssh -Value New-SecureShell

# Finally, export the function
Export-ModuleMember -Alias ssh -Function New-SecureShell