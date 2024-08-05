#TODO: Define class properties for custom output types.
<# class cmdletNoun_Properties {
	#TODO: Determine if defining a class is needed.
	# Class to define a custom output type.  Remove if not needed.  Name the class using the function's noun with "cmdletNoun_Properties" appended.  The function "Get-Stuff" would have the class name "Stuff_Properties".  This is also used for the PSCustomObject name.
	[string]$OutputProperty1
	[int]$OutputProperty2
}#>

function New-mTMDBMovieDirectoryFromRippedDirectory {

<#
	.SYNOPSIS
		From a directory of a ripped DVD or Blu-Ray creates a movie a directory containing using The Movie Database name, release year, and TMDB Id in the standard Plex format.  Optionally moves the new directory to another directory.

    .DESCRIPTION
		A detailed description of the function or script. This keyword can be used only once in each topic.

    .PARAMETER <Parameter-Name>
		The description of a parameter. Add a .PARAMETER keyword for each parameter in the function or script syntax.

    .EXAMPLE
		A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.

    .INPUTS
		The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.

    .OUTPUTS
		The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.

    .NOTES
		Additional information about the function or script.

		Original Author: YOUR NAME HERE, Monster Worldwide GTIS
		Contributors:	 name,org

	.LINK
		https://linktogithublocation

#>
	#TODO: Fill out the comment based help.

<# Comment History
	YYYY-MM-DD username- Initial add
#>

	#TODO: [OutputType([InsertTheOutputTypeOrRemoveTheLine])] #TODO: Update the output type or remove the line.
	[cmdletbinding(SupportsShouldProcess = $false, ConfirmImpact = "High", PositionalBinding = $true, DefaultParameterSetName = "changeme", SupportsPaging = $false, SupportsTransactions = $false, RemotingCapability = 'None', HelpUri = "changeme")]#TODO: Evaluate which cmdletbinding options are appropriate for the script.

	param (
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $false)][System.string]$SourceDirectory,
		[Parameter(Position = 1, Mandatory = $false, ValueFromPipeline = $false)][System.string]$TargetDirectory=((Get-ChildItem $SourceDirectory).Directory).Parent.FullName,
        [Parameter(Position = 2, Mandatory = $true, ValueFromPipeline = $false)][int]$TMDBMovieId,
		[Parameter(Position = 3, Mandatory = $true, ValueFromPipeline = $false)][System.string]$TMDBReadOnlyToken
	)

	begin { # Code to be executed once BEFORE the pipeline is processed goes here.

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function started."

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Begin block start"
		$EAPsaved = $ErrorActionPreference
		#TODO: Maybe protect other preferences?

		# The function Get-mCurrentLine is used in every script and function.
		if (Test-Path -Path function:\Get-mCurrentLine) { Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function Get-mCurrentLine is loaded in the session." }
		else { throw "$(Get-mNow)- $($MyInvocation.InvocationName) - The function Get-mCurrentLine is not loaded in the session." }

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function started."

		# Test for required functions that aren't in required modules.  Remove this section if it's not needed.
		$FunctionList = "Test-mIsModuleLoaded", "Get-mCurrentLine","Search-mTMDBMovie","Get-mTMDBMovieDirectoryBaseName"
		$FunctionList | ForEach-Object {
			if (Test-Path -Path function:\"$($_)") { Write-Verbose -Message "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function $($_) is loaded in the session." }
			else { throw "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function $($_) is not loaded in the session." }
		}

		# Test for required modules.  Internal support modules and vendor specific technology modules in addition to the builtin Microsoft PowerShell modules.  Remove this section if it's not needed.
		$ModuleList = "mPowerShellGenerics"
		$ModuleList | ForEach-Object {
			if (Test-mIsModuleLoaded -Name $_) { Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Module $($_) is loaded in the session." }
			else { throw "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Module $($_) is not loaded in the session." }
		}

        		# Set and Test API credential in API call headers
		$headers=@{}
		$headers.Add("accept", "application/json")
		$headers.Add("Authorization", "Bearer $TMDBReadOnlyToken")

        $response = Invoke-WebRequest -Uri 'https://api.themoviedb.org/3/authentication' -Method GET -Headers $headers
		if ($response.StatusCode -eq 200) {
			Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -TMDBReadOnlyToken authentication succeeded." }
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -TMDBReadOnlyToken authentication succeeded.  Exiting."
			break
		}

        Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Begin block end"

	} # end of the begin block

	process { # Code to be executed against every object in the pipeline goes here.

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Process block start - SourceDirectory $($SourceDirectory) - TargetDirectory $($TargetDirectory) - TMDBMovieId $($TMDBMovieId)" #TODO: Update parameter names.

		#TODO: Validate the parameters as needed.
		if (Test-Path $SourceDirectory) {
            Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($SourceDirectory) exists." }
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($SourceDirectory) does not exist.  Exiting."
			break
		}

		if (Test-Path $TargetDirectory) {
           	Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($TargetDirectory) exists." }
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($TargetDirectory) does not exist.  Exiting."
			break
		}

		# Do the work

		# Get the new base directory and file name using the TMDB movie id.
		$NewBaseName = Get-mTMDBMovieDirectoryBaseName -TMDBMovieId $TMDBMovieId -TMDBReadOnlyToken $TMDBReadOnlyToken
		Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - NewBaseName: $($NewBaseName)"

		mkdir "$($TargetDirectory)\$($NewBaseName)"

		Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - 4 largest files in the directory.`n(Get-ChildItem $SourceDirectory | Where-Object { $_.Length -gt 3.25GB } | Sort-Object Length -Descending | Select-Object -First 4)"

		#TODO: Change max length tested for a variable
		$FileToMoveRename = Get-ChildItem $SourceDirectory | Where-Object { $_.Length -gt 3.11GB } | Sort-Object Length -Descending | Select-Object -First 1
		Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - FileToMoveRename: $($FileToMoveRename)"

		Move-Item $FileToMoveRename "$($TargetDirectory)\$($NewBaseName)\$($NewBaseName).mkv"
		Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - New directory result.`n($($TargetDirectory)\$($NewBaseName))"
		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Process block end"

	} #end of the process block

	end {  # Code to be executed once AFTER the pipeline is processed goes here.  Disconnect server connections, remove variables, reset the transcript file if necessary, and any other cleanup.

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - End block start"
		# When testing comment out "-ErrorAction SilentlyContinue".  This will help find typos, unused variables, and other problems.
		Remove-Variable -Name ModuleList, FunctionList, SourceDirectory, TargetDirectory, TMDBMovieId, TMDBReadOnlyToken, NewBaseName, FileToMoveRename -WhatIf:$false #TODO: When function is production ready uncomment the -ErrorAcction parameter # -ErrorAction SilentlyContinue # Using -WhatIf:$false to suppress unnecessary messages when a calling function has -Whatif:$true enabled.

		[System.GC]::Collect() # Memory cleanup
		$ErrorActionPreference = $EAPsaved

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - End block end"
		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function ended."

	} #end of the end block
	#TODO: Update function name
} # end of the function Verb-Noun (Useful for when you are looking at a function in a PSM1 file.  Can easily see when a function ends.  Can also be used with select string to find the start and end of a function.  I don't have a use case for that last one, but who know?)
