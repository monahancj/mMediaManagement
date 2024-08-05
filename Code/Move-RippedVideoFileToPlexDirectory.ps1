#gci -Path D:\Media\Video\Movies\ -Directory | % { gci -Path $_ -Directory | sort | ft -a } | Out-File MovieList_2023-06-24.txt
#"Drama\Harry Potter Series","Drama\Hunger Games Series","Kids\VeggieTales","Holiday\Peanuts Holiday Collection (2012)","ScienceFiction\Star Wars Series" | % { gci -Path "D:\Media\Video\Movies\$($_)" -Directory | sort | ft -a }

# gci -Path D:\Media\Video\Movies\ -Directory | select -First 1 | % { gci -Path $_.FullName -Directory | sort | select -First 1 | % { $_.Fullgci $_.FullName } }

param(
    [string]$RippingDirectory = 'D:\_ripping',
    [string]$RippedDirName,
    [string]$base,
    [string]$year
)

# TODO: Add manual check.  Show the t00 file and then list all the files by size to verify the t00 file is the main movie file.

#$RippingDirectory = 'D:\_ripping'
#$RippedDirName = "MEET_THE_ROBINSONS_US_D0D0"
#$base = 'The Blues Brothers'
#$year = '1980'

$year = "($($year))"
$NewBasePath = "$($base) $($year)"
$NewExtrasPath = "$($base) Extras $($year)"

$RippedDirName
$base
$year
$RippingDirectory
$NewBasePath
$NewExtrasPath

if (Test-Path $RippingDirectory) { Set-Location $RippingDirectory } else { throw "The ripping directory doesn't exist: $($RippingDirectory)" }
Get-ChildItem $RippedDirName | Sort-Object Length  # To see if the "t00" file is the largest one.  Otherwise exit and investigate.
Pause

if ( (Test-Path $RippedDirName) -and ((Get-ChildItem "$($RippedDirName)\*t00.mkv").Count -eq 1) ) {

    mkdir $NewBasePath
    mkdir $NewExtrasPath

    # Find the main move file and move/rename it.  It's usually the "t00" file.
    Get-ChildItem -Path $RippedDirName -File | Where-Object { $_.Name -notmatch "t00" } | ForEach-Object { Move-Item $_.FullName -Destination $NewExtrasPath }
    Get-ChildItem $RippedDirName,$NewExtrasPath  # Too see what files are there.

    # Move and rename t00 file to the Plex naming convention.
    Set-Location $NewBasePath
    Move-Item -Path (Get-ChildItem "$($RippingDirectory)\$($RippedDirName)\*t00.mkv") -Destination ("$($base)_t00.mkv" -replace("_t00"," $($year)"))

    # Move and rename extra files to the Plex naming convention.
    Set-Location $RippingDirectory\$NewExtrasPath
    Get-ChildItem

    Get-ChildItem | ForEach-Object {
        $_;
        Move-Item -Path $_ -Destination ("$($base) $($year)-$($_.Name)")
    }

    Get-ChildItem  # Too see what files are there.

    Set-Location $RippingDirectory
    Get-ChildItem $RippedDirName,$NewBasePath,$NewExtrasPath
    Get-ChildItem | Sort-Object LastWriteTime -Descending | Select-Object -First 9 -Property LastWriteTime,Name | Format-Table -AutoSize # To see what's next to process.

}
else { throw "Either the ripped movie directory doesn't exist or more than 1 t00.mkv file exists.  Ripped movie directory: $($RippedDirName)" }

