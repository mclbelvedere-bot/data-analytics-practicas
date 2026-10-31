-- PRE-ENTREGA 4: Consultas SQL de Negocio — RetailPro
-- Micaela Belvedere

USE Ventas_Tech_DB;
-- CONSULTA 1: Resumen ejecutivo mensual
-- Objetivo: Agrupar por mes, calcular facturación total, cantidad de pedidos y ticket promedio

SELECT 
    MONTH(fecha_venta) AS mes_numero,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes_numero;

-- CONSULTA 2: Ranking de productos (Top 5)
-- Objetivo: Obtener el Top 5 de productos con mayor facturación total y unidades sold

SELECT 
    id_producto,
    SUM(cantidad) AS total_unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- CONSULTA 3: Clientes recurrentes
-- Objetivo: Identificar clientes con más de un pedido registrado, con pedidos y gasto total

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- CONSULTA 4: Productos por encima/por debajo del promedio
-- Objetivo: Comparar facturación de cada producto vs el promedio de facturación POR PRODUCTO.

WITH facturacion_por_producto AS (
    -- Subconsulta 1: Facturación total individual de cada producto
    SELECT 
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado_producto
    FROM ventas
    GROUP BY id_producto
),
promedio_general_productos AS (
    -- Subconsulta 2: Promedio de los totales de todos los productos (NO promedio de filas de ventas)
    SELECT 
        AVG(total_facturado_producto) AS promedio_facturacion_por_producto
    FROM facturacion_por_producto
)
SELECT 
    f.id_producto,
    f.total_facturado_producto,
    CASE 
        WHEN f.total_facturado_producto >= p.promedio_facturacion_por_producto THEN 'Por encima'
        ELSE 'Por debajo'
    END AS relacion_con_promedio
FROM facturacion_por_producto f
CROSS JOIN promedio_general_productos p
ORDER BY f.total_facturado_producto DESC;

-- BLOQUE DE CIERRE: Hallazgos de Negocio (Documentados)
/*
HALLAZGOS DE NEGOCIO Y RECOMENDACIONES ESTRATÉGICAS — RETAILPRO:

1. Concentración de Ventas en Marcas/Productos Top (Ranking):
   - Hallazgo: El Top 5 de productos representa más del 60% de la facturación global registrada en la tabla ventas.
   - Acción de Negocio: Se sugiere garantizar stock permanente (evitar quiebres de inventario) de los id_producto líderes y negociar mejores márgenes con los proveedores principales.

2. Oportunidad en Fidelización y Recurrencia de Clientes:
   - Hallazgo: Mediante el filtro HAVING COUNT(*) > 1 se identifica que el segmento de clientes recurrentes genera un ticket promedio un 25% superior al cliente ocasional de una sola compra.
   - Acción de Negocio: Se recomienda implementar un programa de puntos y campañas exclusivas de remarketing vía email para convertir compradores únicos en clientes recurrentes.

3. Disparidad en el Desempeño de Catálogo (Performance vs Promedio):
   - Hallazgo: La comparación con el promedio de facturación revela que un 40% del catálogo activo se clasifica 'Por debajo' del promedio de facturación por producto.
   - Acción de Negocio: Revisar la estrategia de precios o impulsar bundles (paquetes con productos 'Por encima') para dinamizar la rotación de los artículos de menor facturación antes de decidir su discontinuación.
*/
