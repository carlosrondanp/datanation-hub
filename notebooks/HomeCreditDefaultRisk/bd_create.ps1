# ================================================
# POSTGRESQL DOCKER - CREAR O ACTIVAR CONTENEDOR
# ================================================
# Este script crea el contenedor si no existe, o lo activa si esta detenido
# Ejecuta este script cada vez que reinicies tu PC o cuando necesites la BD

# === CONFIGURACION ===
$DB_USER = "admin"
$DB_PASSWORD = "admin123"
$DB_PORT = "54330"
$DB_NAME = "home_credit_db"
$CONTAINER_NAME = "postgres_db"
$VOLUME_NAME = "pgdata"

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  POSTGRESQL - HOME CREDIT DEFAULT RISK" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# === PASO 1: VERIFICAR DOCKER ===
Write-Host "[1/4] Verificando Docker..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "Docker funcionando`n" -ForegroundColor Green
} catch {
    Write-Host "Docker no esta corriendo. Iniciando..." -ForegroundColor Red
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Start-Sleep -Seconds 30
}

# === PASO 2: CREAR VOLUMEN (si no existe) ===
Write-Host "[2/4] Verificando volumen..." -ForegroundColor Yellow
$volumeExists = docker volume ls -q -f name=^${VOLUME_NAME}$
if (!$volumeExists) {
    docker volume create $VOLUME_NAME | Out-Null
    Write-Host "Volumen creado`n" -ForegroundColor Green
} else {
    Write-Host "Volumen existe`n" -ForegroundColor Green
}

# === PASO 3: CREAR O ACTIVAR CONTENEDOR ===
Write-Host "[3/4] Verificando contenedor PostgreSQL..." -ForegroundColor Yellow
$containerExists = docker ps -a -q -f name=^${CONTAINER_NAME}$

if (!$containerExists) {
    Write-Host "   Creando contenedor..." -ForegroundColor White
    docker run -d `
      --name $CONTAINER_NAME `
      --restart=always `
      -e POSTGRES_USER=$DB_USER `
      -e POSTGRES_PASSWORD=$DB_PASSWORD `
      -e POSTGRES_DB=$DB_NAME `
      -e POSTGRES_INITDB_ARGS="--auth-host=md5" `
      -e POSTGRES_HOST_AUTH_METHOD=md5 `
      -v ${VOLUME_NAME}:/var/lib/postgresql/data `
      -p ${DB_PORT}:5432 `
      postgres:15 | Out-Null
    
    Write-Host "Contenedor creado exitosamente" -ForegroundColor Green
    Write-Host "Esperando inicializacion (15 segundos)...`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 15
} else {
    $isRunning = docker ps -q -f name=^${CONTAINER_NAME}$
    if (!$isRunning) {
        Write-Host "   Contenedor detenido. Iniciando..." -ForegroundColor White
        docker start $CONTAINER_NAME | Out-Null
        Start-Sleep -Seconds 5
        Write-Host "Contenedor iniciado`n" -ForegroundColor Green
    } else {
        Write-Host "Contenedor ya corriendo`n" -ForegroundColor Green
    }
}

# === PASO 4: VERIFICAR Y MOSTRAR ESTADO ===
Write-Host "[4/4] Verificando estado final..." -ForegroundColor Yellow
$dbExists = docker exec $CONTAINER_NAME psql -U $DB_USER -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" 2>$null

if ($dbExists -eq "1") {
    Write-Host "Base de datos '$DB_NAME' lista`n" -ForegroundColor Green
} else {
    Write-Host "Base de datos '$DB_NAME' creada`n" -ForegroundColor Green
}

# === INFORMACION DE CONEXION ===
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  INFORMACION DE CONEXION:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Host:     127.0.0.1" -ForegroundColor White
Write-Host "  Puerto:   54330" -ForegroundColor White
Write-Host "  Database: home_credit_db" -ForegroundColor White
Write-Host "  Usuario:  admin" -ForegroundColor White
Write-Host "  Password: admin123" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Cyan

# Listar tablas existentes
Write-Host "`nTABLAS EN LA BASE DE DATOS:" -ForegroundColor Yellow
$tables = docker exec $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -tAc "\dt" 2>$null
if ($tables) {
    Write-Host $tables -ForegroundColor White
} else {
    Write-Host "   (No hay tablas aun - usa sesion_1.ipynb para cargar datos)" -ForegroundColor Gray
}

Write-Host "`nSistema listo! Puedes usar sesion_1.ipynb para trabajar con la BD`n" -ForegroundColor Green

# ================================================
# COMANDOS UTILES
# ================================================
# Ver contenedores: docker ps -a
# Detener: docker stop postgres_db
# Iniciar: docker start postgres_db
# Ver logs: docker logs postgres_db
# Conectar bash: docker exec -it postgres_db bash
# Conectar psql: docker exec -it postgres_db psql -U admin -d home_credit_db
# Eliminar contenedor: docker stop postgres_db && docker rm postgres_db
# Eliminar volumen: docker volume rm pgdata
