-- Drop existing tables (FK-safe order)
DROP TABLE IF EXISTS Detalle_Boleta;
DROP TABLE IF EXISTS Boletas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS UsuarioAdmin;

CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    imagen BLOB,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE UsuarioAdmin (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(255) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL DEFAULT 'Cliente',
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Boletas (
    id_boleta INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES UsuarioAdmin(id_usuario)
);

CREATE TABLE Detalle_Boleta (
    id_detalle_boleta INT AUTO_INCREMENT PRIMARY KEY,
    id_boleta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_boleta) REFERENCES Boletas(id_boleta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);