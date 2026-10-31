# TechStore — Consultas Básicas SELECT y Alias

## Respuestas de la práctica

### 1. ¿Por qué es mala práctica usar `SELECT *` en producción?
* **Rendimiento:** Carga columnas innecesarias, consumiendo más memoria RAM, CPU y ancho de banda de la red.
* **Mantenibilidad:** Si la tabla cambia de estructura (se añaden o quitan columnas), los reportes o aplicaciones conectadas pueden romperse.
* **Seguridad:** Expone datos sensibles que no eran requeridos para la consulta.

### 2. ¿Por qué son importantes los alias para un stakeholder no técnico?
Los alias traducen nombres técnicos a un lenguaje de negocio comprensible. 

Por ejemplo, cambiar `total_amount` por `monto_total_ventas` mediante `AS`:
```sql
SELECT total_amount AS monto_total_ventas FROM sales;
