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
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List

# 3. Creación del entorno virtual
# ------------------------------
$venvPath = "intro_venv"
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

    # Obtener el directorio actual
    $currentDir = Get-Location

    # Definir la ruta del archivo requirements.txt en el directorio actual
    $requirementsPath = Join-Path $currentDir "requirements.txt"

    # Verificar si el archivo requirements.txt existe, si no, crearlo
    if (!(Test-Path $requirementsPath)) {
        New-Item -Path $requirementsPath -ItemType File -Force
    }

    # Instalar el paquete
    pip install $packageName

    # Obtener la versión del paquete instalado
    $version = pip freeze | findstr "^$packageName=="

    # Verificar si el paquete ya está en requirements.txt
    if (!(Get-Content $requirementsPath | findstr "^$packageName==")) {
        # Si no está, añadirlo a requirements.txt
        Add-Content -Path $requirementsPath -Value $version
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


# === CONFIGURACIÓN INICIAL ===
$usuario = $env:usuario
$correo = $env:correo
$comentario = "add docker_install.ps1"
$repo_name = "datanation-hub"

# === TOKEN DESDE VARIABLE DE ENTORNO ===
if (-not $env:GITHUB_PAT) {
    Write-Host "❌ ERROR: No se encontró la variable de entorno GITHUB_PAT."
    Write-Host "💡 Establece el token ejecutando: `$env:GITHUB_PAT = 'TU_TOKEN'"
    exit
}

$ruta_git = "https://$env:GITHUB_PAT@github.com/$usuario/$repo_name.git"

# === CONFIGURAR GIT ===
Write-Host "🔹 Configurando GitHub..."
git config --global user.name $usuario
git config --global user.email $correo

# === INICIALIZAR REPO ===
Write-Host "🔹 Inicializando repositorio..."
git init
git add .
git commit -m $comentario

# === CONFIGURAR REMOTO ===
#git remote remove origin -ErrorAction SilentlyContinue
git remote add origin $ruta_git

# === SUBIR CAMBIOS ===
Write-Host "🔹 Subiendo cambios..."
git push --force origin master


# == GUARDAR CREDENCIALES
#git config --global credential.helper store


# === DOCKER ===
# Extensión para VSC
#code --install-extension ms-vscode-remote.remote-wsl