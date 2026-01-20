# ================================================
# Script de Configuración de PostgreSQL con Docker
# ================================================

# === CONFIGURACIÓN ===
$DB_USER = "admin"
$DB_PASSWORD = "admin123"
$DB_PORT = "5433"
$DB_NAME_INICIAL = "testdb"
$NEW_DB_NAME = "home_credit_db"  # Nueva base de datos para el proyecto
$CONTAINER_NAME = "postgres_db"
$VOLUME_NAME = "pgdata"

Write-Host "🔹 Verificando estado de Docker..."
docker ps

Write-Host "`n🔹 Verificando volúmenes existentes..."
docker volume ls

# === CREAR VOLUMEN (solo si no existe) ===
$volumeExists = docker volume ls -q -f name=$VOLUME_NAME
if (!$volumeExists) {
    Write-Host "🔹 Creando volumen $VOLUME_NAME..."
    docker volume create $VOLUME_NAME
} else {
    Write-Host "✅ Volumen $VOLUME_NAME ya existe"
}

# === CREAR CONTENEDOR POSTGRESQL (solo si no existe) ===
$containerExists = docker ps -a -q -f name=$CONTAINER_NAME
if (!$containerExists) {
    Write-Host "🔹 Creando contenedor PostgreSQL..."
    docker run -d `
      --name $CONTAINER_NAME `
      --restart=always `
      -e POSTGRES_USER=$DB_USER `
      -e POSTGRES_PASSWORD=$DB_PASSWORD `
      -e POSTGRES_DB=$DB_NAME_INICIAL `
      -v ${VOLUME_NAME}:/var/lib/postgresql/data `
      -p ${DB_PORT}:5432 `
      postgres:15
    
    Write-Host "✅ Contenedor PostgreSQL creado exitosamente"
    Start-Sleep -Seconds 5  # Esperar a que inicie
} else {
    Write-Host "✅ Contenedor $CONTAINER_NAME ya existe"
    
    # Verificar si está corriendo
    $isRunning = docker ps -q -f name=$CONTAINER_NAME
    if (!$isRunning) {
        Write-Host "🔹 Iniciando contenedor..."
        docker start $CONTAINER_NAME
        Start-Sleep -Seconds 3
    } else {
        Write-Host "✅ Contenedor ya está corriendo"
    }
}

# === CREAR NUEVA BASE DE DATOS (solo si no existe) ===
Write-Host "`n🔹 Verificando si la base de datos '$NEW_DB_NAME' existe..."
$dbExists = docker exec $CONTAINER_NAME psql -U $DB_USER -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$NEW_DB_NAME'"

if ($dbExists -eq "1") {
    Write-Host "✅ Base de datos '$NEW_DB_NAME' ya existe"
} else {
    Write-Host "🔹 Creando base de datos '$NEW_DB_NAME'..."
    docker exec $CONTAINER_NAME psql -U $DB_USER -d postgres -c "CREATE DATABASE $NEW_DB_NAME;"
    Write-Host "✅ Base de datos '$NEW_DB_NAME' creada exitosamente"
}

# === LISTAR BASES DE DATOS ===
Write-Host "`n🔹 Bases de datos disponibles:"
docker exec $CONTAINER_NAME psql -U $DB_USER -d postgres -c "\l"

# === CREAR TABLA DE EJEMPLO EN LA NUEVA BASE DE DATOS ===
Write-Host "`n🔹 Creando tabla 'clientes' en '$NEW_DB_NAME'..."

$SQL_CREATE_TABLE = @"
CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  edad INTEGER,
  fecha_reg DATE
);
"@

docker exec $CONTAINER_NAME psql -U $DB_USER -d $NEW_DB_NAME -c $SQL_CREATE_TABLE

# === INSERTAR DATOS DE PRUEBA ===
$SQL_INSERT_DATA = @"
INSERT INTO clientes (nombre, email, edad, fecha_reg) 
SELECT * FROM (VALUES
  ('Ana Pérez', 'ana@gmail.com', 28, '2024-06-12'::date),
  ('Luis Soto', 'luis@example.com', 35, '2024-05-30'::date),
  ('María León', 'maria@correo.com', 42, '2023-12-01'::date),
  ('Jorge Díaz', NULL, 30, '2025-01-15'::date),
  ('Lucía Torres', 'lucia.torres@gmail.com', NULL, CURRENT_DATE)
) AS v(nombre, email, edad, fecha_reg)
WHERE NOT EXISTS (SELECT 1 FROM clientes LIMIT 1);
"@

docker exec $CONTAINER_NAME psql -U $DB_USER -d $NEW_DB_NAME -c $SQL_INSERT_DATA

Write-Host "✅ Tabla 'clientes' configurada"

# === CONSULTAR DATOS ===
Write-Host "`n🔹 Datos en la tabla 'clientes':"
docker exec $CONTAINER_NAME psql -U $DB_USER -d $NEW_DB_NAME -c "SELECT * FROM clientes;"

# === INFORMACIÓN DE CONEXIÓN ===
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "📌 CONEXIÓN DESDE DBEAVER / PYTHON:"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "   Host:          localhost"
Write-Host "   Puerto:        $DB_PORT"
Write-Host "   Base de datos: $NEW_DB_NAME"
Write-Host "   Usuario:       $DB_USER"
Write-Host "   Contraseña:    $DB_PASSWORD"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

Write-Host "`n✅ ¡Proceso completado exitosamente!"

# ================================================
# COMANDOS ÚTILES
# ================================================

# | Parámetro          | Explicación                                                            |
# | ------------------ | ---------------------------------------------------------------------- |
# | `--name`           | Nombre único del contenedor                                            |
# | `--restart=always` | Hace que el contenedor se levante automáticamente al reiniciar Docker  |
# | `-e`               | Define variables de entorno (usuario, contraseña, nombre de BD, etc.)  |
# | `-v`               | Crea/monta un volumen Docker (datos persistentes en el disco del host) |
# | `-p`               | Mapea un puerto del contenedor al puerto del sistema anfitrión         |
# | `postgres:15`      | Imagen usada de Docker Hub (puedes cambiar la versión si lo necesitas) |

#docker stop postgres_db      # Detiene el contenedor
#docker rm postgres_db        # Elimina el contenedor (sin borrar datos)
#docker volume rm pgdata      # Elimina los volumenes
