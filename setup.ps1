# ================================================
# Configuración de entornos virtuales en PowerShell
# ================================================

Write-Host "🔹 Verificando instalación de Python..."
python --version

# 1. Instalación de virtualenv y actualización de pip
# --------------------------------------------------
Write-Host "🔹 Actualizando pip e instalando virtualenv..."
python -m pip install --upgrade pip
python -m pip install virtualenv

# 2. Ajuste de políticas de ejecución de scripts
# ----------------------------------------------
Write-Host "🔹 Ajustando políticas de ejecución..."
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List

# 3. Creación del entorno virtual
# ------------------------------
$venvPath = "ds_venv"
Write-Host "🔹 Creando entorno virtual en $venvPath ..."
python -m virtualenv $venvPath --python="C:\Program Files\Python312\python.exe"

# 4. Activación del entorno virtual
# --------------------------------
Write-Host "🔹 Activando entorno virtual..."
& ".\$venvPath\Scripts\activate.ps1"

# ================================================
# Automatización de instalación de paquetes en PowerShell
# ================================================

# 5. Verificación y creación del perfil de PowerShell
# --------------------------------------------------
Write-Host "🔹 Verificando perfil de PowerShell..."
if (!(Test-Path $profile)) {
    New-Item -Path $profile -ItemType File -Force
}
notepad $profile

# 6. Función para instalar paquetes y actualizar requirements.txt
# ---------------------------------------------------------------
function Install-And-Log {
    param (
        [string]$packageName
    )

    $requirementsPath = "$venvPath\requirements.txt"
    if (!(Test-Path $requirementsPath)) {
        Write-Host "🔹 Creando requirements.txt..."
        New-Item -Path $requirementsPath -ItemType File -Force
    }

    try {
        Write-Host "🔹 Instalando paquete: $packageName..."
        pip install $packageName
        $version = pip freeze | findstr "^$packageName=="

        if (!(Get-Content $requirementsPath | findstr "^$packageName==")) {
            Add-Content -Path $requirementsPath -Value $version
        }
    } catch {
        Write-Host "⚠️ Error al instalar el paquete: $packageName"
    }
}

# 7. Recargar el perfil y probar la función
# ----------------------------------------
Write-Host "🔹 Recargando perfil..."
. $profile
Install-And-Log -packageName "pandas"

# ================================================
# Configuración de GitHub
# ================================================

Write-Host "🔹 Configurando GitHub..."
git config --global user.name "{usuario}"
git config --global user.email "{correo}"

Write-Host "🔹 Inicializando repositorio..."
git init
git add .
git commit -m "Primer commit"
git remote add origin https://{clave}@github.com/carlosrondanp/datanation-hub.git

Write-Host "🔹 Subiendo cambios..."
git push --force origin master
