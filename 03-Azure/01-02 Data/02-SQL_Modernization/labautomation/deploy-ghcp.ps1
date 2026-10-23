$ErrorActionPreference = 'Stop'

$location       = 'swedencentral'
$lab            = 'C:\Users\mhaenggi\repos\MicroHack\03-Azure\01-02 Data\02-SQL_Modernization\labautomation'
$sharedRg       = 'rg-sqlhack-shared'
$personalRg     = 'rg-sqlhack-personal'

# Point to your corrected, approved copy. Use a simple branch name.
$repoBaseURL = 'https://raw.githubusercontent.com/mhaenggi01/MicroHack/main/03-Azure/01-02%20Data/02-SQL_Modernization/labautomation'

Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId
Set-AzContext -SubscriptionId $subscriptionId

$vmPassword  = Read-Host 'VM administrator password' -AsSecureString
$sqlPassword = Read-Host 'SQL administrator password' -AsSecureString
$tenantId       = Read-Host 'tenantId' -AsSecureString
$subscriptionId = Read-Host 'subscriptionId' -AsSecureString

New-AzResourceGroup -Name $sharedRg -Location $location

$sharedParameters = @{
    environmentName    = 'sqlhack'
    location           = $location
    adminUsername      = 'DemoUser'
    adminPassword      = ([System.Net.NetworkCredential]::new('', $vmPassword)).Password
    sqlMiAdminUsername = 'DemoUser'
    sqlMiAdminPassword = ([System.Net.NetworkCredential]::new('', $sqlPassword)).Password
    legacySQLName      = 'legacySQL2016'
    arcSQLName         = 'arcSQL2022'
    repoBaseURL        = $repoBaseURL
}

New-AzSubscriptionDeployment `
    -Name 'sqlhack-shared' `
    -Location $location `
    -TemplateFile "$lab\infra\main-shared.bicep" `
    -TemplateParameterObject $sharedParameters `
    -WhatIf
