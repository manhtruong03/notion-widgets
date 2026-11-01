param(
    [Parameter(Mandatory = $true)]
    [string]$Id,

    [Parameter(Mandatory = $true)]
    [string]$Title,

    [Parameter(Mandatory = $true)]
    [ValidateSet("learning", "work", "productivity", "utilities")]
    [string]$Category,

    [Parameter(Mandatory = $false)]
    [string]$Group = "",

    [Parameter(Mandatory = $true)]
    [string]$Description,

    [Parameter(Mandatory = $true)]
    [string]$SourceHtmlPath,

    [Parameter(Mandatory = $false)]
    [string]$TargetFileName = "",

    [Parameter(Mandatory = $false)]
    [string[]]$Tags = @(),

    [Parameter(Mandatory = $false)]
    [int]$RecommendedHeight = 420,

    [Parameter(Mandatory = $false)]
    [bool]$GitPush = $true
)

$ErrorActionPreference = "Stop"
$repoDir = "D:\manhtc\projects\notion-widgets"
$baseUrl = "https://manhtruong03.github.io/notion-widgets"

if (-not (Test-Path -LiteralPath $SourceHtmlPath)) {
    throw "Source HTML file not found: $SourceHtmlPath"
}

if (-not $TargetFileName) {
    $TargetFileName = Split-Path -Path $SourceHtmlPath -Leaf
}

$relDir = if ($Group) { "widgets/$Category/$Group" } else { "widgets/$Category" }
$destDir = Join-Path $repoDir ($relDir -replace '/', '\')
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

$destFile = Join-Path $destDir $TargetFileName
$relPath = "$relDir/$TargetFileName"
$embedUrl = "$baseUrl/$relPath"

# Compute relative path to shared/ directory so theme CSS & runtime bridge are always linked
$depth = ($relDir -split '/').Count
$upPrefix = ("../" * $depth).TrimEnd('/')
$htmlContent = Get-Content -LiteralPath $SourceHtmlPath -Raw -Encoding UTF8

if ($htmlContent -notmatch 'notion-theme\.css') {
    $injectHead = @"
<head>
  <link rel="stylesheet" href="$upPrefix/shared/notion-theme.css" />
  <script src="$upPrefix/shared/notion-widget.js"></script>
"@
    $htmlContent = $htmlContent -replace '<head>', $injectHead
}

Set-Content -LiteralPath $destFile -Value $htmlContent -Encoding UTF8

# Update registry.json
$regPath = Join-Path $repoDir "registry.json"
$reg = Get-Content -LiteralPath $regPath -Raw -Encoding UTF8 | ConvertFrom-Json
$widgetsList = [System.Collections.ArrayList]@($reg.widgets)

$newEntry = [PSCustomObject][ordered]@{
    id                 = $Id
    title              = $Title
    category           = $Category
    group              = $Group
    path               = $relPath
    embed_url          = $embedUrl
    description        = $Description
    tags               = $Tags
    recommended_height = $RecommendedHeight
    updated_at         = (Get-Date -Format "yyyy-MM-dd")
}

$existingIdx = -1
for ($i = 0; $i -lt $widgetsList.Count; $i++) {
    if ($widgetsList[$i].id -eq $Id -or $widgetsList[$i].path -eq $relPath) {
        $existingIdx = $i
        break
    }
}

if ($existingIdx -ge 0) {
    $widgetsList[$existingIdx] = $newEntry
} else {
    [void]$widgetsList.Add($newEntry)
}

$reg.widgets = @($widgetsList)
$reg | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $regPath -Encoding UTF8

if ($GitPush) {
    Push-Location $repoDir
    try {
        git add .
        $status = git status --porcelain
        if ($status) {
            git commit -m "feat(widget): publish $Id ($relPath)" | Out-Null
            git push -u origin main | Out-Null
        }
    } finally {
        Pop-Location
    }
}

[PSCustomObject][ordered]@{
    id        = $Id
    local_file = $destFile
    rel_path  = $relPath
    embed_url = $embedUrl
    pushed    = $GitPush
} | ConvertTo-Json -Depth 4
