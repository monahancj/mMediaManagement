[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $Directory
)

Get-ChildItem -Path $Directory -Directory -Recurse | ForEach-Object {
    $_
    $DirectoryTotalTime = 0
    Get-ChildItem -Path $_ | Where-Object { $_.Extension -match "flac|ogg|mp3" } | ForEach-Object { 
        $TrackTotalTime = (Measure-Command { ffplay -nodisp -autoexit $_ 2> $null }).Seconds
        # $TrackTotalTime
        $DirectoryTotalTime += $TrackTotalTime
    }
    $DirectoryTotalTime
    $DirectoryTotalTime | Out-File "$($_.FullName)\$($_.BaseName)._DurationInSeconds.txt" -Force
}
