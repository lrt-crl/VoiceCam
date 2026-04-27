# VoiceCam

🌐 **[Visita la Landing Page](https://lrt-crl.github.io/VoiceCam)**

VoiceCam es una solución para conectar tu móvil Android a tu PC con Windows, permitiendo compartir la cámara, el micrófono y utilizar dictado por voz (STT) que escribe directamente en el teclado de tu ordenador.

## 🚀 Instalación Rápida

Puedes descargar los instaladores y el APK desde la sección de **[Releases](https://github.com/lrt-crl/VoiceCam/releases/latest)**.

### 1. Preparación del PC (Windows)
1.  Descarga el `voice-cam-windows-bundle.zip`.
2.  Extrae el contenido.
3.  Haz clic derecho sobre `install_drivers.ps1` y selecciona **"Ejecutar con PowerShell"**. Esto descargará e instalará automáticamente:
    - **VB-CABLE**: Para el audio virtual.
    - **UnityCapture**: Para la cámara virtual.
4.  Reinicia el PC si es necesario.

### 2. Preparación del Móvil (Android)
1.  Descarga el `voice-cam-android-apk`.
2.  Instálalo en tu dispositivo Android.
3.  Asegúrate de conceder permisos de Cámara y Micrófono.

## 🛠️ Uso

1.  Abre `voice_cam_desktop.exe` en tu PC.
2.  Pulsa **"Start Server"**. Verás tu dirección IP local.
3.  Abre la app en tu móvil e introduce esa IP.
4.  **Cámara/Micro**: Pulsa "Start Streaming".
5.  **Dictado por Voz**: Pulsa "Voice Typist". Habla al móvil y el texto aparecerá donde tengas el cursor en el PC.

## 🏗️ Estructura del Proyecto

- `voice_cam_mobile`: App Flutter (Android).
- `voice_cam_desktop`: Panel de control Flutter (Windows).
- `voice_cam_core`: Backend en Rust con integración de **Whisper** (IA para voz a texto) y **Enigo** (simulación de teclado).
- `.github/workflows`: Flujo de integración continua para compilación automática.

## ⚖️ Requisitos de Desarrollo

Si deseas compilar el proyecto manualmente:
- Flutter SDK (stable)
- Rust Toolchain
- Android SDK & NDK
- Visual Studio con soporte C++ (para Windows Desktop)
