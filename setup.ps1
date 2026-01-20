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
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Get-ExecutionPolicy -List

# 3. Creación del entorno virtual (solo si no existe)
# --------------------------------------------------
$venvPath = "ds_venv"
if (Test-Path $venvPath) {
    Write-Host "✅ El entorno virtual ya existe en $venvPath"
} else {
    Write-Host "🔹 Creando entorno virtual en $venvPath ..."
    python -m virtualenv $venvPath --python="C:\Program Files\Python312\python.exe"
}

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
    Write-Host "✅ Perfil de PowerShell creado"
}

# 6. Función para instalar paquetes y actualizar requirements.txt
# ---------------------------------------------------------------
function Install-And-Log {
    param (
        [string]$packageName
    )

    $currentDir = Get-Location
    $requirementsPath = Join-Path $currentDir "requirements.txt"

    if (!(Test-Path $requirementsPath)) {
        New-Item -Path $requirementsPath -ItemType File -Force
    }

    pip install $packageName
    $version = pip freeze | findstr "^$packageName=="

    if (!(Get-Content $requirementsPath | findstr "^$packageName==")) {
        Add-Content -Path $requirementsPath -Value $version
    }
}
# 7. Recargar el perfil y probar la función
# ----------------------------------------
Write-Host "🔹 Recargando perfil..."
. $profile
Install-And-Log -packageName "psycopg2"

# ================================================
# Configuración de GitHub
# ================================================

# === CONFIGURAR .gitignore ===
$gitignorePath = ".gitignore"
if (!(Test-Path $gitignorePath)) {
    New-Item -Path $gitignorePath -ItemType File -Force
}

$envPsPattern = "env.ps1"
if (!(Get-Content $gitignorePath -ErrorAction SilentlyContinue | Select-String -Pattern "^env\.ps1$")) {
    Add-Content -Path $gitignorePath -Value "`n# Archivo con información confidencial`nenv.ps1"
    Write-Host "✅ env.ps1 añadido a .gitignore"
}

# === CONFIGURACIÓN INICIAL ===
$usuario = $env:usuario
$correo = $env:correo
$comentario = "Actualización automática - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
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

# === INICIALIZAR REPO (solo si no existe) ===
if (!(Test-Path ".git")) {
    Write-Host "🔹 Inicializando repositorio..."
    git init
} else {
    Write-Host "✅ Repositorio ya inicializado"
}

# === AGREGAR CAMBIOS ===
Write-Host "🔹 Agregando cambios..."
git add .
git commit -m $comentario

# === CONFIGURAR REMOTO (solo si no existe) ===
$remoteExists = git remote | Select-String -Pattern "^origin$"
if (!$remoteExists) {
    Write-Host "🔹 Configurando remoto..."
    git remote add origin $ruta_git
} else {
    Write-Host "✅ Remoto ya configurado"
}

# === SUBIR CAMBIOS ===
Write-Host "🔹 Subiendo cambios..."
git push origin master

Write-Host "✅ ¡Proceso completado exitosamente!"