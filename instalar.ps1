# Instala la skill director-proyecto en el perfil del usuario.
# Por defecto crea un enlace (junction) para que los cambios del proyecto se reflejen de inmediato.
# Uso: .\instalar.ps1 [-Copia] [-Forzar]
param([switch]$Copia, [switch]$Forzar)
$ErrorActionPreference = 'Stop'
$origen  = Join-Path $PSScriptRoot 'skills\director-proyecto'
$carpeta = Join-Path $env:USERPROFILE '.claude\skills'
$destino = Join-Path $carpeta 'director-proyecto'

if (-not (Test-Path $origen)) { throw "No se encuentra la skill en $origen" }
New-Item -ItemType Directory -Force -Path $carpeta | Out-Null

if (Test-Path $destino) {
    if (-not $Forzar) {
        Write-Host "Ya existe $destino. Ejecute de nuevo con -Forzar para reemplazarla."
        exit 1
    }
    $item = Get-Item $destino -Force
    if ($item.LinkType) { $item.Delete() } else { Remove-Item $destino -Recurse -Force }
}

if ($Copia) {
    Copy-Item $origen $destino -Recurse
    Write-Host "Skill copiada en $destino"
} else {
    New-Item -ItemType Junction -Path $destino -Target $origen | Out-Null
    Write-Host "Skill enlazada: $destino -> $origen"
}
