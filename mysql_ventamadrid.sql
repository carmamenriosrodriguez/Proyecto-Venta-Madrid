CREATE DATABASE Proyecto_Venta_Madrid; 

USE Proyecto_Venta_Madrid;

SELECT
m.provincia,
m.zona,
m.titulo,
m.precio_actual,
m.metros,
m.habitaciones,
m.ascensor,
m.planta, 
m.baños,
m.cod_distrito,
r.renta_neta_media_por_hogar
FROM tabla_madrid as m
LEFT JOIN tabla_renta as r
ON m.cod_distrito = r.cod_distrito;

/* Hacemos el LEFT JOIN de ambas tablas */

/* Una vez aquí, decidimos cambiar la columna renta_neta_media_por_hogar por el año rnmh_2023*/

ALTER TABLE tabla_renta
RENAME COLUMN renta_neta_media_por_hogar TO rnmh_2023;

/* 1. Queremos añadir una columna extra calculando la rnmh por la iflación desde 2023 a 2025 */
/* Renta 2025=Renta 2023 ×(1+IPC 2024)×(1+IPC 2025) */ 
/* BENCHMARK: url de info del ipc = https://www.ine.es/prensa/ipc_tabla.htm */

SELECT
m.provincia,
m.zona,
m.titulo,
m.precio_actual,
m.metros,
m.habitaciones,
m.ascensor,
m.planta, 
m.baños,
m.cod_distrito,
r.rnmh_2023, 
ROUND((r.rnmh_2023 * 1.028 * 1.029), 0) as rnmh_2025 
FROM tabla_madrid as m
LEFT JOIN tabla_renta as r
ON m.cod_distrito = r.cod_distrito;






