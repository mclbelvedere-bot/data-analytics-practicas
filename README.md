# RetailPro — Proyecto de Análisis de Datos (`Ventas_Tech_DB`)

Repositorio de prácticas y entregables del proyecto **RetailPro**, enfocado en el diseño de bases de datos relacionales, consultas SQL analíticas, modelado con JOINs y visualización en Power BI.

## Estructura del repositorio

* `ventas_tech_db.sql`: Script DDL y DML inicial. Crea las tablas `categorias`, `clientes`, `productos` y `ventas`, e inserta los registros base de prueba.
* `modulo2_unidad2_inventario.sql`: Consultas iniciales de control de inventario y catálogo.
* `actividad_unidad3_diseno.sql`: Ejercicios de diseño y normalización del modelo relacional.
* `consultas_basicas.sql`: Consultas exploratorias de filtrado y agregación simple.
* `m4_consultas_negocio.sql`: Consultas analíticas de negocio sobre `Ventas_Tech_DB` (resumen ejecutivo mensual, ranking Top 5 de productos, clientes recurrentes y comparación contra el promedio mediante CTEs).
* `m5_consultas_joins.sql`: Consultas de integración con `INNER JOIN`, `LEFT JOIN`, `UNION ALL` y simulación portable de `FULL OUTER JOIN`.
* `Entregable_Unidad6_PowerBI.pdf`: Documentación del modelo analítico y reporte visual en Power BI.

## Herramientas utilizadas

* **Motor SQL:** MySQL / MariaDB
* **Visualización:** Microsoft Power BI
* **Control de versiones:** Git & GitHub

## Cómo ejecutar los scripts

1. Ejecutar primero `ventas_tech_db.sql` para crear la estructura de tablas y cargar los datos de referencia.
2. Ejecutar `m4_consultas_negocio.sql` (el script incluye `USE Ventas_Tech_DB;` al inicio para seleccionar la base automáticamente).
3. *Nota de compatibilidad:* Las consultas de `m5_consultas_joins.sql` trabajan sobre el modelo conceptual ampliado del Módulo 5 (incorporando atributos dimensionales como `region_id`, `segmento` y `tipo_origen`).
