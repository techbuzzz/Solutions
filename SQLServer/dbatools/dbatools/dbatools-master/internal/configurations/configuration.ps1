<#	

#-------------------------#
# Warning Warning Warning #
#-------------------------#

This is the global configuration management file.

DO NOT EDIT THIS FILE!!!!!
Disobedience shall be answered by the wrath of Fred.
You've been warned.
;)

The purpose of this file is to manage the configuration system.
That means, messing with this may mess with every function using this infrastructure.
Don't, unless you know what you do.

#---------------------------------------#
# Implementing the configuration system #
#---------------------------------------#

The configuration system is designed, to keep as much hard coded configuration out of the functions.
Instead we keep it in a central location: The Configuration store (= this folder).

In Order to put something here, either find a configuration file whose topic suits you and add configuration there,
or create your own file. The configuration system is loaded last during module import process, so you have access to all
that dbatools has to offer (Keep module load times in mind though).

Examples are better than a thousand words:

a) Setting the configuration value
# Put this in a configuration file in this folder
Set-DbaConfig -Name 'Path.DbatoolsLog' -Value "$($env:AppData)\PowerShell\dbatools" -Default

b) Retrieving the configuration value in your function
# Put this in the function that uses this setting
$path = Get-DbaConfigValue -Name 'Path.DbatoolsLog' -FallBack $env:temp

# Explanation #
#-------------#

In step a), which is run during module import, we assign the configuration of the name 'Path.DbatoolsLog' the value "$($env:AppData)\PowerShell\dbatools"
Unless there already IS a value set to this name (that's what the '-Default' switch is doing).
That means, that if a user had a different configuration value in his profile, that value will win. Userchoice over preset.
ALL configurations defined by the module should be 'default' values.

In step b), which will be run whenever the function is called within which it is written, we retrieve the value stored behind the name 'Path.DbatoolsLog'.
If there is nothing there (for example, if the user accidentally removed or nulled the configuration), then it will fall back to using "$($env:temp)\dbatools.log"

#>



$configpath = $ExecutionContext.SessionState.Module.ModuleBase + "\internal\configurations"

# Import configuration handlers
foreach ($file in (Get-ChildItem -Path $configpath -Filter "*.handler.ps1"))
{
    . ([scriptblock]::Create([io.file]::ReadAllText($file.FullName)))
}

#region Implement user profile
if ($var = Get-Variable "dbatools_config" -Scope Global -ErrorAction Ignore)
{
    if ($var.Value.GetType().FullName -eq "System.Management.Automation.ScriptBlock")
    {
        $var.Value.Invoke()
    }
}
#endregion Implement user profile

# Import other configuration files
foreach ($file in (Get-ChildItem -Path $configpath -Exclude "configuration.ps1", "*.handler.ps1"))
{
    . ([scriptblock]::Create([io.file]::ReadAllText($file.FullName)))
}