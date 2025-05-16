# ================================================
# Configuración de entornos virtuales en PowerShell
# ================================================

# 1. Instalación de virtualenv y actualización de pip
# --------------------------------------------------
# Asegúrate de tener Python instalado antes de ejecutar estos comandos.
python -m pip install --upgrade pip
python -m pip install virtualenv

# 2. Ajuste de políticas de ejecución de scripts
# ----------------------------------------------
# Esto permite que PowerShell ejecute scripts sin restricciones de seguridad innecesarias.
# * Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List

# 3. Creación del entorno virtual
# ------------------------------
# Reemplaza la ruta de Python con la correcta en tu sistema.
python -m virtualenv ds_venv --python="C:\Program Files\Python312\python.exe"

# 4. Activación del entorno virtual
# --------------------------------
.\ds_venv\Scripts\activate.ps1

# ================================================
# Automatización de instalación de paquetes en PowerShell
# ================================================

# 5. Verificación y creación del perfil de PowerShell
# --------------------------------------------------
# Se comprueba si el archivo de perfil existe, y si no, se crea.
if (!(Test-Path $profile)) {
    New-Item -Path $profile -ItemType File -Force
}
notepad $profile

# En el archivo de perfil, agrega la siguiente función para instalar paquetes automáticamente:

# 6. Función para instalar paquetes y actualizar requirements.txt
# ---------------------------------------------------------------
function Install-And-Log {
    param (
        [string]$packageName
    )

    # Obtener el directorio actual
    $currentDir = Get-Location

    # Definir la ruta del archivo requirements.txt
    $requirementsPath = Join-Path $currentDir "requirements.txt"

    # Verificar si el archivo requirements.txt existe, si no, crearlo
    if (!(Test-Path $requirementsPath)) {
        New-Item -Path $requirementsPath -ItemType File -Force
    }

    # Instalar el paquete con manejo de errores
    try {
        pip install $packageName
        $version = pip freeze | findstr "^$packageName=="

        # Si el paquete no está en requirements.txt, añadirlo
        if (!(Get-Content $requirementsPath | findstr "^$packageName==")) {
            Add-Content -Path $requirementsPath -Value $version
        }
    } catch {
        Write-Host "Error al instalar el paquete: $packageName"
    }
}

# 7. Recargar el perfil y probar la función
# ----------------------------------------
. $profile
Install-And-Log -packageName "pandas"





## GITHUB
git config --global user.name "crondanp"
git config --global user.email "carlos.rondan.p@uni.pe"


git init
git add .