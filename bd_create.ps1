docker ps                # contenedores corriendo
docker volume ls         # volúmenes creados

## Creamos los volumenes fijos
docker volume create pgdata
docker volume create mysqldata


## Creamos los contenedores (1 vez o cuando lo eliminamos)
# PostgreSQL
# version: https://hub.docker.com/_/postgres
docker run -d \
  --name postgres_db \                          # Nombre del contenedor
  --restart=always \                            # Se reinicia automáticamente con Docker
  -e POSTGRES_USER=admin \                      # Usuario principal
  -e POSTGRES_PASSWORD=admin123 \               # Contraseña del usuario
  -e POSTGRES_DB=testdb \                       # Nombre de la base de datos inicial
  -v pgdata:/var/lib/postgresql/data \          # Volumen persistente donde se guardan los datos
  -p 5432:5432 \                                # Mapea el puerto del contenedor al host
  postgres:15                                   # Imagen base (versión 15)

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

# Eliminar todo
#docker rm -f postgres_db && docker volume rm pgdata

# Verificar eliminación
#docker ps -a

#Dbeaver
# | Campo         | Valor                                     |
# | ------------- | ----------------------------------------- |
# | Host          | `localhost`                               |
# | Puerto        | `5432`                                    |
# | Base de datos | `testdb`                                  |
# | Usuario       | `admin`                                   |
# | Contraseña    | `admin123`                                |
# | Driver        | PostgreSQL (viene por defecto en DBeaver) |

### CARGAR DATOS Y PROBAR:
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  edad INTEGER,
  fecha_reg DATE
);
INSERT INTO clientes (nombre, email, edad, fecha_reg) VALUES
('Ana Pérez', 'ana@gmail.com', 28, '2024-06-12'),
('Luis Soto', 'luis@example.com', 35, '2024-05-30'),
('María León', 'maria@correo.com', 42, '2023-12-01'),
('Jorge Díaz', NULL, 30, '2025-01-15'),
('Lucía Torres', 'lucia.torres@gmail.com', NULL, CURRENT_DATE);
select *
  from clientes 


# MySQL
# version: https://hub.docker.com/_/mysql
docker run -d \
  --name mysql_db \
  --restart=always \
  -e MYSQL_ROOT_PASSWORD=admin123 \
  -e MYSQL_DATABASE=testdb_mysql \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin1234 \
  -v mysqldata:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8

#docker stop mysql_db      # Detiene el contenedor
#docker rm mysql_db        # Elimina el contenedor (sin borrar datos)
#docker volume rm mysqldata      # Elimina los volumenes

# Eliminar todo
#docker rm -f mysql_db && docker volume rm mysqldata

# Verificar eliminación
#docker ps -a

#Dbeaver
# | Campo         | Valor           |
# | ------------- | -----------     |
# | Host          | `localhost`     |
# | Puerto        | `3306`          |
# | Base de datos | `testdb_mysql`  |
# | Usuario       | `admin`         |
# | Contraseña    | `admin1234`     |
# | Driver        | MySQL           |

#allowPublicKeyRetrieval=true y useSSL=false

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  edad INT,
  fecha_reg DATE
);
INSERT INTO clientes (nombre, email, edad, fecha_reg) VALUES
('Ana Pérez', 'ana@gmail.com', 28, '2024-06-12'),
('Luis Soto', 'luis@example.com', 35, '2024-05-30'),
('María León', 'maria@correo.com', 42, '2023-12-01'),
('Jorge Díaz', NULL, 30, '2025-01-15'),
('Lucía Torres', 'lucia.torres@gmail.com', NULL, CURDATE());
select *
  from clientes


# Eliminar imagen: docker rmi <<IMAGE ID>>

# --restart=always hace que se levanten automáticamente si Docker arranca al encender tu PC.

# | Motor      | Host        | Puerto | Usuario | Contraseña  | DB Inicial |
# | ---------- | ----------- | ------ | ------- | ----------- | ---------- |
# | PostgreSQL | `localhost` | 5432   | `admin` | `admin123`  | `testdb`   |
# | MySQL      | `localhost` | 3306   | `admin` | `admin1234`  | `testdb`   |


##### REUSARL BD

# En caso reinicie la computadora, encendemos Docker Desktop
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
docker info
docker ps
docker start postgres_db
docker start mysql_db
