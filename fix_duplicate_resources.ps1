# Script PowerShell para renombrar meta.xml de recursos duplicados en [gamemodes]
# Esto evita que MTA detecte recursos duplicados

$ResourcesDir = "resources\[gamemodes]"
$DuplicateResources = @("admin", "freecam", "glue", "interiors", "realdriveby", "runcode", "scoreboard", "superman")

Write-Host "Renombrando meta.xml de recursos duplicados en [gamemodes]..." -ForegroundColor Yellow
Write-Host ""

foreach ($resource in $DuplicateResources) {
    $MetaFile = Join-Path $ResourcesDir "$resource\meta.xml"
    $BackupFile = Join-Path $ResourcesDir "$resource\meta.xml.disabled"
    
    if (Test-Path $MetaFile) {
        Write-Host "Renombrando: $MetaFile -> $BackupFile" -ForegroundColor Cyan
        Rename-Item -Path $MetaFile -NewName "meta.xml.disabled" -Force
        Write-Host "  ✓ $resource deshabilitado" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ $resource no encontrado (puede que ya esté deshabilitado)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "¡Completado! Los recursos duplicados han sido deshabilitados." -ForegroundColor Green
Write-Host "Para reactivarlos, renombra meta.xml.disabled de vuelta a meta.xml" -ForegroundColor Yellow

