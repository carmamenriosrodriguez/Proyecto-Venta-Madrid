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

SELECT 
    m.cod_distrito,
    r.rnmh_2023,
    ROUND((r.rnmh_2023 * 1.028 * 1.029), 0) AS rnmh_2025
FROM tabla_madrid AS m
LEFT JOIN tabla_renta AS r
    ON m.cod_distrito = r.cod_distrito
GROUP BY m.cod_distrito, r.rnmh_2023
ORDER BY
cod_distrito;

-- H1: ¿Cuál es la diferencia de precio medio entre pisos con y sin ascensor? 
SELECT
	ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END) - AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS diff,
	zona,
	ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END), 0) AS con_ascensor,
	ROUND(AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS sin_ascensor
FROM tabla_madrid
WHERE metros > 0
GROUP BY
	zona
ORDER BY
    diff DESC;
    
/* El Retiro y el Barrio de Salamanca presentan la mayor diferencia de precio, 
donde tener ascensor encarece el metro cuadrado en 2.154 € y 1.939 € respectivamente.
Villaverde y Vicálvaro presentan las menores diferencias de toda la lista, 
con apenas 351 € y 344 € por metro cuadrado de diferencia respectivamente.*/
    
    	-- H1.1: ¿Y en pisos de una o dos habitaciones? 

SELECT
	habitaciones,
    ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END) - AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS diff,
	ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END), 0) AS con_ascensor,
	ROUND(AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS sin_ascensor
FROM tabla_madrid
WHERE metros > 0
GROUP BY
	habitaciones
HAVING
	habitaciones = 1 OR habitaciones = 2
ORDER BY
    diff DESC;
/* Para pisos de dos habitaciones, la diferencia es de 2945€, lo que sugiere que el ascensor se valora más según el tamaño de la vivienda. 
En los pisos de una sola habitación, la diferencia se reduce a 1513€. 
Además, el precio medio de un piso de 1 habitación sin ascensor (4960€) 
es incluso más alto que el de 2 habitaciones sin ascensor (4543€) */


        -- H1.2: ¿Y según planta?
SELECT
 planta,
    ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END) - AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS diff,
 ROUND(AVG(CASE WHEN ascensor = 'S' THEN precio_actual / metros END), 0) AS con_ascensor,
 ROUND(AVG(CASE WHEN ascensor = 'N' THEN precio_actual / metros END), 0) AS sin_ascensor
FROM tabla_madrid
WHERE metros > 0
GROUP BY
 planta
HAVING
 planta = 'BAJO' 
    OR planta = '1ª' 
    OR planta = '2ª' 
    OR planta = '3ª' 
    OR planta = '4ª' 
    OR planta = '5ª' 
    OR planta = '6ª' 
    OR planta = '7ª' 
    OR planta = '8ª' 
    OR planta = '9ª' 
    OR planta = '10ª'
	OR planta = '11ª' 
    OR planta = '12ª' 
    OR planta = '13ª' 
    OR planta = '14ª' 
    OR planta = '15ª' 
    OR planta = '16ª' 
    OR planta = '17ª' 
    OR planta = '18ª' 
    OR planta = '19ª' 
    OR planta = '20ª'
ORDER BY
    diff DESC;
/* La presencia de ascensor es un factor determinante en el precio, 
cuya importancia se intensifica drásticamente a medida que aumenta la altura de la vivienda. 
Mientras que en los bajos la diferencia de precio es mínima (1267€), 
en una 14ª planta la brecha alcanza su máximo de 5696€, 
evidenciando que un piso alto sin ascensor pierde gran parte de su valor de mercado.
Además, a ausencia de datos (NULL) en la mayoría de las plantas superiores a la 13ª 
para viviendas sin ascensor refleja una realidad arquitectónica y normativa, 
donde el ascensor es prácticamente obligatoria en grandes alturas. */
    
-- H2 ¿Dónde es más asequible comprar un piso según la renta? 
SELECT
m.zona, 
m.cod_distrito,
ROUND(AVG(m.precio_actual), 2) as precio_medio,
ROUND(AVG(rnmh_2023 * 1.028 * 1.029), 0) as rnmh_2025,
ROUND(AVG(m.precio_actual)/ AVG(r.rnmh_2023 * 1.028 * 1.029), 2) as ratio
FROM tabla_madrid as m
LEFT JOIN tabla_renta as r
ON m.cod_distrito = r.cod_distrito
GROUP BY 
m.zona, 
m.cod_distrito
ORDER BY 
ratio ASC; 
/* Villaverde y Puente de Vallecas son las zonas más asequibles, 
ya que requieren invertir solo entre 5.34 y 5.55 años de renta íntegra para comprar una vivienda.
Vicálvaro y Carabanchel son las zonas menos asequibles, con ratios extremos de 78.68 y 70.05, 
lo que sugiere un desequilibrio total entre precios y rentas locales. */


-- H4 ¿Cuántos años de renta íntegra (100% del salario sin gastar en nada más) se necesitan para pagar la entrada (20% del precio) en cada distrito?
SELECT 
m.zona,
m.cod_distrito,
ROUND(AVG(m.precio_actual * 0.20) / (SELECT AVG(rnmh_2023 * 1.028 * 1.029) FROM tabla_renta), 2) as años
FROM tabla_madrid AS m
GROUP BY 
m.zona, 
m.cod_distrito
ORDER BY años DESC;
/* Habría que destinar casi 8 años de renta para poder adquirir el 20% de entrada de venta en el Barrio de Salamanca,
unos 7 en Chamartín y unos 6 y medio en Moncloa. Por el contrario, para un piso en Vallecas solo son tres cuartos de año, 
como en Villaverde y en Usera un año completo */ 


-- H5 Índice de asequibilidad: renta/precio x m2 
SELECT
	m.zona,
    ROUND((MAX(r.rnmh_2023) * 1.028 * 1.029)/(AVG(m.precio_actual)/AVG(m.metros)), 0) AS ratio_asequibilidad
FROM tabla_madrid AS m
LEFT JOIN tabla_renta AS r
	ON m.cod_distrito = r.cod_distrito
GROUP BY
	m.zona,
    m.cod_distrito
ORDER BY
	ratio_asequibilidad DESC;

/* Ciudad lineal por cada metro cuadrado paga 23 veces el metro cuadrado con su renta.
Seguido de Moncloa y Hortaleza con un ratio del 17. 
En el otro lado, tendríamos empatados vicalvaro y Carabanchel, cuyo ratio es 1:1. 
Después se situaría Barrio de Salamanca y Centro. */



