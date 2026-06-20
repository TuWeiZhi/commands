# GudaCC Commands Installer for Windows
# https://github.com/GuDaStudio/commands

param(
    [Alias("u")][switch]$User,
    [Alias("p")][switch]$Project,
    [Alias("t")][string]$Target,
    [Alias("h")][switch]$Help
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$CommandName = "gudaspec"

function Write-ColorOutput {
    param(
        [string]$Text,
        [string]$Color = "White",
        [switch]$NoNewline
    )
    if ($NoNewline) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Text -ForegroundColor $Color
    }
}

function Show-Usage {
    Write-ColorOutput "GudaCC Commands Installer" "Blue"
    Write-Host ""
    Write-Host "Usage: .\install.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -User, -u              Install to user-level (~\.claude\commands\)"
    Write-Host "  -Project, -p           Install to project-level (.\.claude\commands\)"
    Write-Host "  -Target, -t <path>     Install to custom target path"
    Write-Host "  -Help, -h              Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\install.ps1 -User"
    Write-Host "  .\install.ps1 -Project"
    Write-Host "  .\install.ps1 -Target C:\custom\path"
}

function Install-Command {
    param([string]$TargetDir)

    $sourceDir = Join-Path $ScriptDir $CommandName
    $destDir = Join-Path $TargetDir $CommandName

    if (-not (Test-Path $sourceDir -PathType Container)) {
        Write-ColorOutput "Error: '$CommandName' not found in source directory" "Red"
        return $false
    }

    Write-Host "Installing " -NoNewline
    Write-ColorOutput "$CommandName" "Cyan" -NoNewline
    Write-Host " -> $destDir"

    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    if (Test-Path $destDir) {
        Write-ColorOutput "  Removing existing installation..." "Yellow"
        Remove-Item -Path $destDir -Recurse -Force
    }

    Copy-Item -Path $sourceDir -Destination $destDir -Recurse

    $gitFile = Join-Path $destDir ".git"
    if (Test-Path $gitFile -PathType Leaf) {
        Remove-Item -Path $gitFile -Force
    }

    Write-ColorOutput "  ✓ Installed" "Green"
    return $true
}

if ($Help) {
    Show-Usage
    exit 0
}

$TargetPath = ""
if ($User) {
    $TargetPath = Join-Path $env:USERPROFILE ".claude\commands"
} elseif ($Project) {
    $TargetPath = ".\.claude\commands"
} elseif ($Target) {
    $TargetPath = $Target
}

if (-not $TargetPath) {
    Write-ColorOutput "Error: Please specify installation target (-User, -Project, or -Target)" "Red"
    Write-Host ""
    Show-Usage
    exit 1
}

Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-ColorOutput "GudaCC Commands Installer" "Blue"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-Host ""
Write-Host "Target: " -NoNewline
Write-ColorOutput $TargetPath "Green"
Write-Host "Command: " -NoNewline
Write-ColorOutput $CommandName "Green"
Write-Host ""

Install-Command -TargetDir $TargetPath

Write-Host ""
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Green"
Write-ColorOutput "Installation complete!" "Green"
Write-ColorOutput "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Green"
