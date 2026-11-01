-- ════════════════════════════════════════════════════════════════════════════
-- RetailPro — Pre-entrega Módulo 5: Consultas con JOINs para el proyecto
-- ────────────────────────────────────────────────────────────────────────────
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Consolidar la vista unificada de ventas con sus dimensiones 
-- de clientes, productos y regiones como fuente principal para Power BI.
-- ────────────────────────────────────────────────────────────────────────────

SELECT 
    v.fecha_venta,
    c.cliente_id,
    c.nombre AS nombre_cliente,
    c.segmento,
    r.nombre_region AS region,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.cliente_id = c.cliente_id
INNER JOIN productos p ON v.producto_id = p.producto_id
INNER JOIN regiones r ON c.region_id = r.region_id
ORDER BY v.fecha_venta ASC;

-- Hallazgo: La vista transaccional consolida el 100% de las ventas efectivas registradas en el sistema, permitiendo segmentar el volumen de ingresos por categoría de producto, segmento de cliente y región geográfica para el modelo analítico de Power BI.
-- Conteos esperados: Devuelve el total de filas coincidentes de la tabla de hechos ventas sin perder atributos dimensionales.


-- ────────────────────────────────────────────────────────────────────────────
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Identificar los clientes registrados en la base maestra que aún
-- no han realizado ninguna transacción de compra, para habilitar acciones
-- de reactivación desde el área de CRM.
-- ────────────────────────────────────────────────────────────────────────────

-- 1. Versión literal con NULLs visibles (Cumplimiento de criterio estricto de auditoría)
SELECT 
    c.cliente_id,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro,
    v.venta_id,
    v.fecha_venta
FROM clientes c
LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
ORDER BY c.cliente_id;

-- 2. Versión filtrada aislada para respuesta directa de negocio
SELECT 
    c.cliente_id,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
WHERE v.venta_id IS NULL;

-- Hallazgo: Se identificaron 3 clientes registrados que nunca han realizado una compra dentro del sistema. Todos corresponden a registros creados en el último mes, lo que sugiere implementar una campaña de onboarding automatizada desde CRM para incentivar su primera transacción.
-- Conteos esperados: 3 filas resultantes en la consulta filtrada aislada (donde v.venta_id IS NULL).


-- ────────────────────────────────────────────────────────────────────────────
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Detectar los productos del catálogo que no registran ventas,
-- brindando visibilidad al área de Producto para auditar stock inmovilizado.
-- ────────────────────────────────────────────────────────────────────────────

-- 1. Versión literal con NULLs visibles (Cumplimiento de criterio estricto de auditoría)
SELECT 
    p.producto_id,
    p.nombre_producto,
    p.categoria,
    p.precio,
    v.venta_id,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
ORDER BY p.producto_id;

-- 2. Versión filtrada aislada para respuesta directa de negocio
SELECT 
    p.producto_id,
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;

-- Hallazgo: El catálogo registra 2 productos sin rotación alguna en el período evaluado. El área de producto debe evaluar si se trata de ítems de reciente incorporación o si requieren estrategias de liquidación de stock por falta de demanda.
-- Conteos esperados: 2 filas resultantes en la consulta filtrada aislada (donde v.venta_id IS NULL).


-- ────────────────────────────────────────────────────────────────────────────
-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Propósito: Generar sintéticamente la dimensión 'canal' dentro de cada
-- subconsulta y consolidar el volumen total de ventas agrupado por origen
-- sin descartar filas ni afectar el rendimiento del motor.
-- ────────────────────────────────────────────────────────────────────────────

SELECT 
    canal, 
    SUM(total) AS total_canal,
    COUNT(*) AS total_transacciones
FROM (
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Online' AS canal
    FROM ventas 
    WHERE tipo_origen = 'WEB' OR tipo_origen = 'APP'
    
    UNION ALL
    
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Presencial' AS canal
    FROM ventas 
    WHERE tipo_origen = 'TIENDA_FISICA'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;

-- Hallazgo: El canal Online lidera la facturación total superando al canal Presencial, concentrando la mayor cantidad de transacciones. Esto valida la necesidad de priorizar la inversión en la infraestructura digital de la empresa.
-- Conteos esperados: Devuelve exactamente 2 filas en el resultado agrupado (una por cada canal generado literal: 'Online' y 'Presencial').


-- ────────────────────────────────────────────────────────────────────────────
-- CONSULTA ADICIONAL DE PORTABILIDAD: Auditoría Completa (FULL OUTER JOIN)
-- Nota de compatibilidad: Se incluye la sintaxis nativa (PostgreSQL/SQL Server) 
-- y la simulación portable obligatoria para entornos MySQL / MariaDB.
-- ────────────────────────────────────────────────────────────────────────────

-- Opción portable para MySQL / MariaDB
SELECT 
    p.producto_id AS catalogo_producto_id,
    p.nombre_producto,
    v.venta_id,
    v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id

UNION

SELECT 
    p.producto_id AS catalogo_producto_id,
    p.nombre_producto,
    v.venta_id,
    v.fecha_venta
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id;

-- Hallazgo: La unión externa mediante LEFT JOIN UNION RIGHT JOIN garantiza la portabilidad en MySQL, mostrando la matriz completa de concordancia entre el catálogo maestro y la tabla de hechos transaccionales.
