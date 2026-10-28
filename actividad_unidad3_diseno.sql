-- -----------------------------------------------------------------------------
-- 1. TABLA: clientes
-- -----------------------------------------------------------------------------
CREATE TABLE clientes (
    id_cliente INT, 
    -- INT: Número entero ideal para identificadores únicos (IDs) sin decimales.

    nombre VARCHAR(100), 
    -- VARCHAR(100): Texto de longitud variable para nombres completos. 
    -- Permite hasta 100 caracteres optimizando el espacio en memoria.

    perfil_bio VARCHAR(MAX), 
    -- VARCHAR(MAX): Tipo de dato adecuado para textos largos, notas o biografías 
    -- de extensión indefinida. (En PostgreSQL se puede usar TEXT).

    fecha_registro DATE 
    -- DATE: Almacena únicamente la fecha (Año-Mes-Día) sin hora, perfecto para 
    -- registrar el día en que se dio de alta el cliente.
);
GO

-- -----------------------------------------------------------------------------
-- 2. TABLA: productos
-- -----------------------------------------------------------------------------
CREATE TABLE productos (
    id_producto INT, 
    -- INT: Clave numérica entera para identificar de forma única a cada producto.

    descripcion VARCHAR(255), 
    -- VARCHAR(255): Texto de longitud variable de hasta 255 caracteres para 
    -- descripciones comerciales detalladas del artículo.

    precio DECIMAL(10, 2), 
    -- DECIMAL(10,2): Garantiza precisión exacta para valores monetarios (dinero). 
    -- Soporta hasta 10 dígitos en total, de los cuales 2 son decimales (ej. 99999998.99).

    esta_activo BIT 
    -- BIT: Tipo lógico booleano estándar en SQL Server (1 = Verdadero / Activo, 0 = Falso / Inactivo). 
    -- Es la opción más liviana e ideal para indicar si el producto está disponible para la venta.
);
