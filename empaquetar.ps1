# Genera dist\director-proyecto.skill (un zip con la carpeta de la skill, sin los casos de prueba).
$ErrorActionPreference = 'Stop'
$origen = Join-Path $PSScriptRoot 'skills\director-proyecto'
$dist   = Join-Path $PSScriptRoot 'dist'
$temp   = Join-Path $env:TEMP ("director-skill-" + [guid]::NewGuid())
$zip    = Join-Path $dist 'director-proyecto.zip'
$skill  = Join-Path $dist 'director-proyecto.skill'

New-Item -ItemType Directory -Force -Path $dist | Out-Null
New-Item -ItemType Directory -Force -Path $temp | Out-Null
Copy-Item $origen (Join-Path $temp 'director-proyecto') -Recurse
Remove-Item (Join-Path $temp 'director-proyecto\evals') -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item $zip, $skill -Force -ErrorAction SilentlyContinue
Compress-Archive -Path (Join-Path $temp 'director-proyecto') -DestinationPath $zip
Rename-Item $zip 'director-proyecto.skill'
Remove-Item $temp -Recurse -Force
Write-Host "Paquete generado: $skill"
