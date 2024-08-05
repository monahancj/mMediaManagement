#TODO: Define class properties for custom output types.
<# class cmdletNoun_Properties {
	#TODO: Determine if defining a class is needed.
	# Class to define a custom output type.  Remove if not needed.  Name the class using the function's noun with "cmdletNoun_Properties" appended.  The function "Get-Stuff" would have the class name "Stuff_Properties".  This is also used for the PSCustomObject name.
	[string]$OutputProperty1
	[int]$OutputProperty2
}#>

function Update-mTMDBMovieDirectoryAndFileToIncludeTMDBID {

<#
	.SYNOPSIS
		Updates a directory containing a movie to use the The Movie Database name, release year, and TMDB Id in the standard Plex format.

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
	2023-10-02 monahancj - Initial add
#>

	#TODO: [OutputType([InsertTheOutputTypeOrRemoveTheLine])] #TODO: Update the output type or remove the line.
	[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", PositionalBinding = $true, SupportsPaging = $false, SupportsTransactions = $false, RemotingCapability = 'None', HelpUri = "changeme")]#TODO: Evaluate which cmdletbinding options are appropriate for the script.

	param (
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $false)][System.string]$Directory,
		[Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false)][int]$TMDBMovieId,
		[Parameter(Position = 2, Mandatory = $true, ValueFromPipeline = $false)][System.string]$TMDBReadOnlyToken
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

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Process block start - Directory $($Directory)" #TODO: Update parameter names.

		# Save the directory.  Will revert back to the starting directory before exiting.
		$ParentDirectory = (Get-ChildItem $Directory).Directory.Parent

		# Validate the parameters as needed.
		if (Test-Path $Directory) {
            Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($Directory) exists." }
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Parameter -Directory as $($Directory) does not exist.  Exiting."
			break
		}

		if (Test-Path $Directory) {
            Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Movie File as $($Directory) exists." }
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Movie File as $($Directory) does not exist.  Exiting."
			break
		}
		if ( (Get-ChildItem $Directory).BaseName -eq ((Get-ChildItem $Directory).Directory -split("\\"))[-1] ) {
			Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Directory and movie file base names match. Proceeding.  Base name: $((Get-ChildItem $Directory).BaseName)"}
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Directory and movie file base names do not match. Directory base name: $(((Get-ChildItem $Directory).Directory -split("\\"))[-1]) -- Movie file base name: $(Get-ChildItem $Directory).BaseName)"
		}

		# Do the work

		# Get the new base directory and file name using the TMDB movie id.
		$CurrentBaseName = (gci $Directory).Directory.Name
		$NewBaseName = Get-mTMDBMovieDirectoryBaseName -TMDBReadOnlyToken $TMDBReadOnlyToken -TMDBMovieId $TMDBMovieId
		Write-Verbose -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - NewBaseName: $($NewBaseName)"

		# Rename the file(s) before the directory so the file variable doesn't because invalid.
		if (Test-Path $Directory) {
			Set-Location -Path $Directory

			if (Test-Path *_mkv_JRSidecar.xml) { Move-Item "$($CurrentBaseName)_mkv_JRSidecar.xml" "$($NewBaseName)_mkv_JRSidecar.xml" }
			if (Test-Path "$($CurrentBaseName).jpg") { Move-Item "$($CurrentBaseName).jpg" "$($NewBaseName).jpg" }
			if (Test-Path "$($CurrentBaseName).mkv") { Move-Item "$($CurrentBaseName).mkv" "$($NewBaseName).mkv" }
			else { Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - MKV file doesn't exist: $($CurrentBaseName).mkv)" }

			Set-Location ..
			if (Test-Path $Directory) { Move-Item $Directory $NewBaseName }
			else { Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Source directory doesn't exist: $($Directory)" }
		}
		else {
			Write-Error -Message "$(get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Source directory doesn't exist: $($Directory)" }

		# Revert to the starting directory.
		Set-Location $ParentDirectory

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Process block end"

	} #end of the process block

	end {  # Code to be executed once AFTER the pipeline is processed goes here.  Disconnect server connections, remove variables, reset the transcript file if necessary, and any other cleanup.

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - End block start"
		# When testing comment out "-ErrorAction SilentlyContinue".  This will help find typos, unused variables, and other problems.
		Remove-Variable -Name ModuleList, FunctionList, Directory, TMDBMovieId, TMDBReadOnlyToken, CurrentBaseName, NewBaseName, ParentDirectory -WhatIf:$false #TODO: When function is production ready uncomment the -ErrorAcction parameter # -ErrorAction SilentlyContinue # Using -WhatIf:$false to suppress unnecessary messages when a calling function has -Whatif:$true enabled.

		[System.GC]::Collect() # Memory cleanup
		$ErrorActionPreference = $EAPsaved

		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - End block end"
		Write-Verbose "$(Get-mNow)- $($MyInvocation.InvocationName) - Line $(Get-mCurrentLine) - Function ended."

	} #end of the end block
} # end of the function Update-mTMDBMovieDirectoryAndFileToIncludeTMDBID (Useful for when you are looking at a function in a PSM1 file.  Can easily see when a function ends.  Can also be used with select string to find the start and end of a function.  I don't have a use case for that last one, but who know?)
