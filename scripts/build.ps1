# Build the PDF from the Markdown source using Pandoc (Windows PowerShell).
# Usage:  .\scripts\build.ps1            (build PDF)
#         .\scripts\build.ps1 tex        (build LaTeX instead of PDF)
#
# Run this from the project root (the folder that contains "document\").

param(
    [string]$Format = "pdf"   # "pdf" (default) or "tex"
)

$ErrorActionPreference = "Stop"

# Resolve the project root as the parent of this script's directory,
# so the script works no matter where it is called from.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir   = Split-Path -Parent $ScriptDir
Set-Location $RootDir

$Src    = "document\paper.md"
$Bib    = "document\references.bib"
$Csl    = "document\numeric.csl"
$OutDir = "generated"
$Out    = Join-Path $OutDir "paper.$Format"

if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir | Out-Null
}

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Error "pandoc is not installed or not on your PATH. See the README for installation instructions."
    exit 1
}

Write-Host "Building $Out from $Src ..."
pandoc $Src `
    -s `
    --citeproc `
    --csl=$Csl `
    --bibliography=$Bib `
    --resource-path="document" `
    -o $Out

Write-Host "Done: $Out"
