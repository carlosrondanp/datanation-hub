## Instalar Docker
1. https://docs.docker.com/desktop/setup/install/windows-install/
2. documentación --> Microsoft documentation.
3. wsl --install
3.1 wsl -l -v --> Validar si tenemos al kernel
4. Reiniciar + ingresar a ubuntu
5. Habilita WSL y la plataforma de máquina virtual
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

5. Regresar a documentación --> virtualizacion
6. ir a "features of windows" o "características de windows"
7. activamos "virtual machine Platform" + "subsistema de windows para linux"
8. Instalar docker desde web o desde WSL (curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh) 
9. instalar docker desktop
10. docker --version
11. docker info
12. docker run hello-world

13. Cuando reiniciamos la computadora ejecutar Docker Desktop: Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"