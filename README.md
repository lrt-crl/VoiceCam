# VoiceCam

VoiceCam es una solución para conectar tu móvil Android a tu PC con Windows, permitiendo compartir la cámara, el micrófono y utilizar dictado por voz (STT) que escribe directamente en el teclado de tu ordenador.

## Características

- **Cámara Virtual**: Usa la cámara de tu móvil como una webcam en Windows.
- **Micrófono Virtual**: Transmite el audio del móvil al PC con baja latencia.
- **Escritura por Voz**: Dicta al móvil y el PC escribirá el texto automáticamente usando Whisper (local).
- **Conexión Dual**: Soporta WiFi y USB (vía ADB).

## Requisitos Previos

Para que el sistema funcione correctamente, debes instalar los siguientes componentes en tu PC:

1.  **Cámara Virtual**: Se recomienda [UnityCapture](https://github.com/schellingb/UnityCapture) o el driver de Media Foundation incluido.
2.  **Audio Virtual**: Instala [VB-CABLE Virtual Audio Device](https://vb-audio.com/Cable/) para recibir el sonido del móvil como una entrada de micrófono.
3.  **ADB (opcional)**: Si deseas usar conexión por USB, asegúrate de tener instalados los drivers de Android y habilitada la "Depuración USB" en el móvil.

## Instalación y Uso

### 1. Servidor de PC (Desktop)

1.  Navega a la carpeta `voice_cam_desktop`.
2.  Ejecuta `flutter run -d windows` para iniciar la interfaz de control.
3.  Asegúrate de que el backend de Rust (`voice_cam_core`) esté compilado.
4.  Pulsa "Start Server" para comenzar a escuchar conexiones.

### 2. Aplicación Móvil (Android)

1.  Instala el APK generado en `voice_cam_mobile/build/app/outputs/flutter-apk/app-debug.apk`.
2.  Abre la app e introduce la dirección IP que aparece en la aplicación de escritorio.
3.  Pulsa "Start Streaming" para la cámara/micro o "Voice Typist" para el dictado.

## Desarrollo

### Estructura del Proyecto
- `voice_cam_mobile`: App Flutter para Android.
- `voice_cam_desktop`: App Flutter para Windows.
- `voice_cam_core`: Lógica central en Rust (WebSockets, STT Whisper, Simulación de teclado).

### Compilación del Core (Rust)
```bash
cd voice_cam_core
cargo build --release
```

## Notas
- El dictado por voz utiliza el modelo Whisper "tiny" para asegurar fluidez en CPUs estándar.
- La primera vez que uses el dictado, el sistema puede tardar unos segundos en cargar el modelo de IA.
