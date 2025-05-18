------------------------------------------------------------
🐳 GUÍA DE INSTALACIÓN DE DOCKER EN WINDOWS CON WSL2
------------------------------------------------------------

Esta guía te permite instalar Docker correctamente en Windows 10/11 
utilizando WSL2 y Docker Desktop. Está estructurada paso a paso y 
comentada para evitar errores comunes.

------------------------------------------------------------
1. DOCUMENTACIÓN OFICIAL
------------------------------------------------------------

- Docker Desktop: https://docs.docker.com/desktop/setup/install/windows-install/
- WSL en Windows: https://learn.microsoft.com/en-us/windows/wsl/install

------------------------------------------------------------
2. HABILITAR WSL2 EN WINDOWS
------------------------------------------------------------

Paso 1: Abrir PowerShell como administrador y ejecutar:

    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Paso 2: Reiniciar el sistema.

------------------------------------------------------------
3. INSTALAR UBUNTU EN WSL2
------------------------------------------------------------

Para instalar Ubuntu:

    wsl --install

Si ya tienes Ubuntu instalado, verifica si está en WSL2:

    wsl -l -v

Si la columna VERSION muestra "1", cambiarla a WSL2:

    wsl --set-version Ubuntu 2

------------------------------------------------------------
4. VERIFICAR QUE ESTÁS EN WSL2
------------------------------------------------------------

Dentro de Ubuntu en WSL, ejecutar:

    uname -r

Debe mostrar algo como:

    5.15.xxxx-microsoft-standard-WSL2

Si no aparece "-WSL2" en el nombre, aún no estás en WSL2.

------------------------------------------------------------
5. ACTIVAR FUNCIONES DESDE WINDOWS
------------------------------------------------------------

Ir a:

    Panel de control > Activar o desactivar características de Windows

Asegurarse de que estén activadas:

    [x] Virtual Machine Platform
    [x] Subsistema de Windows para Linux

------------------------------------------------------------
6. INSTALAR DOCKER DESKTOP
------------------------------------------------------------

Descargar desde:

    https://www.docker.com/products/docker-desktop/

Durante la instalación:

    - Aceptar "Use WSL 2 instead of Hyper-V"
    - Seleccionar tu distro Ubuntu como integrada (puede hacerse luego también)

Después de la instalación, reiniciar si lo solicita.

------------------------------------------------------------
7. CONFIGURAR WSL EN DOCKER DESKTOP
------------------------------------------------------------

Abrir Docker Desktop.

Ir a:

    Settings > Resources > WSL Integration

Activar el checkbox de tu distro (ej. Ubuntu).

------------------------------------------------------------
8. VALIDAR INSTALACIÓN DESDE WSL (Ubuntu)
------------------------------------------------------------

Abrir Ubuntu y ejecutar:

    docker --version
    docker info
    docker run hello-world

Si aparece error de permisos:

    sudo usermod -aG docker $USER
    newgrp docker

Luego volver a ejecutar `docker run hello-world`

------------------------------------------------------------
9. NO EJECUTAR ESTO SI USAS DOCKER DESKTOP
------------------------------------------------------------

No uses este script si ya tienes Docker Desktop:

    curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

Este script instala el Docker Engine clásico, que no funciona bien en WSL 
sin daemon propio. Docker Desktop ya incluye el daemon necesario.

------------------------------------------------------------
10. VERIFICACIÓN FINAL (RESUMEN RÁPIDO)
------------------------------------------------------------

    docker --version
    docker info
    docker run hello-world

El último comando debería mostrar:

    Hello from Docker!
    This message shows that your installation appears to be working correctly.

------------------------------------------------------------
FIN DE LA GUÍA
------------------------------------------------------------
