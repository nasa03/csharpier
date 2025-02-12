﻿# this uses https://github.com/microsoft/PowerShellForGitHub
# you'll need to Set-GitHubAuthentication first

param (
    [Parameter(Mandatory=$true)]
    [string]$previousVersionNumber,
    [Parameter(Mandatory=$true)]
    [string]$versionNumber
)

if ($versionNumber -eq "" -or $previousVersionNumber -eq "") {
    Write-Output "Supply version numbers [previous] [current]"
    exit 1;
}

$ErrorActionPreference = "Stop"

$repository = "https://github.com/belav/csharpier"

# if this fails
# Install-Module -Name PowerShellForGitHub
$milestones = Get-GitHubMilestone -Uri $repository -State "Open"
$milestoneNumber = -1
foreach($milestone in $milestones) {
    if ($milestone.title -eq $versionNumber) {
        $milestoneNumber = $milestone.number
    }
}

$issues = Get-GitHubIssue -Uri https://github.com/belav/csharpier -MilestoneNumber $milestoneNumber -State All

$content = [System.Text.StringBuilder]::new()
$content.AppendLine("# " + $versionNumber)
$content.AppendLine("## What's Changed")
foreach ($issue in $issues) {
    if ($issue.title.ToLower().Contains("checklist")) {
        continue
    }
    
    $content.AppendLine("#### " + $issue.title + " [#" + $issue.number +"](" + $issue.html_url + ")")
}
$content.AppendLine()
$content.AppendLine("**Full Changelog**: https://github.com/belav/csharpier/compare/" + $previousVersionNumber + "..." + $versionNumber)

Write-Output $content.ToString()
