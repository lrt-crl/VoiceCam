# Script para descargar e instalar drivers necesarios para VoiceCam

Write-Host "Iniciando descarga de drivers..." -ForegroundColor Cyan

# 1. VB-CABLE (Audio Virtual)
$vbCableUrl = "https://download.vb-audio.com/Download_Html/VBCABLE_Driver_Pack43.zip"
$vbCableZip = "$PSScriptRoot\VBCABLE.zip"
$vbCableDir = "$PSScriptRoot\VBCABLE_Install"

Write-Host "Descargando VB-CABLE..."
Invoke-WebRequest -Uri $vbCableUrl -OutFile $vbCableZip
Expand-Archive -Path $vbCableZip -DestinationPath $vbCableDir -Force

Write-Host "Instalando VB-CABLE (Requiere permisos de Administrador)..."
Start-Process -FilePath "$vbCableDir\VBCABLE_Setup_x64.exe" -ArgumentList "/i" -Wait -Verb RunAs

# 2. UnityCapture (Cámara Virtual)
# Nota: UnityCapture suele requerir registro manual de filtros DirectShow
Write-Host "Descargando UnityCapture..."
$unityUrl = "https://github.com/schellingb/UnityCapture/archive/refs/heads/master.zip"
$unityZip = "$PSScriptRoot\UnityCapture.zip"
Invoke-WebRequest -Uri $unityUrl -OutFile $unityZip
Expand-Archive -Path $unityZip -DestinationPath "$PSScriptRoot\UnityCapture" -Force

Write-Host "Registrando Filtro de Cámara Virtual..."
$registerScript = "$PSScriptRoot\UnityCapture\UnityCapture-master\Install.bat"
Start-Process -FilePath "cmd.exe" -ArgumentList "/c $registerScript" -Wait -Verb RunAs

Write-Host "Instalación de drivers completada." -ForegroundColor Green
Write-Host "Por favor, reinicia el sistema si los dispositivos no aparecen."
