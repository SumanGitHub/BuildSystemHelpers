# These are project build parameters in Build
# Depending on the branch, we will use different major/minor versions
$majorMinorVersionMaster = "1.1.1"
$majorMinorVersionDevelop = "1.1.0"

Write-Host "Master = " + $majorMinorVersionMaster
Write-Host  "Dev = " + $majorMinorVersionDevelop
# Bamboo's auto-incrementing build counter; ensures each build is unique
Write-Host $env:bamboo_buildNumber
$value = $env:bamboo_buildNumber;

# This gets the name of the current Git branch. 
$branch = $env:bamboo_repository_git_branch

# Sometimes the branch will be a full path, e.g., 'refs/heads/master'. 
# If so we'll base our logic just on the last part.
if ($branch.Contains("/")) 
{
  $branch = $branch.substring($branch.lastIndexOf("/")).trim("/")
}

Write-Host "Branch: $branch"

if ($branch -eq "master") 
{
 $buildNumber = "${majorMinorVersionMaster}.${value}"
}
elseif ($branch -eq "development") 
{
 $buildNumber = "${majorMinorVersionDevelop}.${value}"
}
elseif ($branch -match "release-.*") 
{
 $specificRelease = ($branch -replace 'release-(.*)','$1')
 $buildNumber = "${specificRelease}.${value}"
}
else
{
 # If the branch starts with "feature-", just use the feature name
 $branch = $branch.replace("feature-", "")
 $buildNumber = "${majorMinorVersionDevelop}.${value}-${branch}"
}

Write-Host "buildNumber: " + $buildNumber
setx OctopackBuildNumber $buildNumber 
setx OctopackBuildNumber $buildNumber /m
set OctopackBuildNumber=$buildNumber 
Write-Host "buildNumber written"