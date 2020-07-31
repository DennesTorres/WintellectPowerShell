function Set-References
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "", Scope="Function")]
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(ValueFromPipeline, Mandatory=$true)]
        [System.IO.FileInfo[]] $Path,
        [string[]] $CustomConfigurationProperties = @(),
        [parameter(Mandatory=$true)]
        [String]$DacpacFolder
    )

    begin
    {
        Import-Module Set-ArtifactReference
        function Get-ReplaceTable()
        {
            [hashtable]$newTable=@{};

            foreach ($newItem in $CustomConfigurationProperties)
            {
                $newPath= "$DacpacFolder\$newItem"
                $newTable.Add($newItem,$newPath)
            }
            return $newTable;
        }
        function Execute()
        {
            $hash=Get-ReplaceTable
            Set-ArtifactReference -Path $Path -CustomConfigurationProperties $hash   2>&1 | Write-Host
        }
    }
    process
    {
        if ($PSCmdlet.ShouldProcess($path, "Updating settings"))
        {
            Write-Verbose "Processing : $path"
            Execute
        }
    }
    end
    {
    }
}