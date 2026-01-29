
# SE VENDE MADRID · Radiografía de la asequibilidad inmobiliaria por distritos (Madrid)
*Artículo periodístico basado en datos (Idealista + INE).*

**Juan José Ruiz Bellido**  
**Carmen Ríos Rodríguez** 

## Objetivo
Este análisis busca desvelar la brecha entre el precio de mercado de los inmuebles vendidos y la capacidad económica real de los hogares madrileños. Investigamos si existe una correlación directa entre la renta neta media y el acceso a la propiedad, o si factores externos (especulación, turismo) están rompiendo el equilibrio habitacional de la capital.

Entregamos, un ranking un ranking por distrito/zona que permite identificar **dónde se compra con más/menos esfuerzo** y **qué variables (ascensor, planta, tipología) encarecen más**.

## Contexto de negocio 
- El artículo derivado de este proyecto se dirige a un público general (no técnico).
- Madrid enfrenta una escalada de precios que parece desconectada de los salarios locales así que creemos que, como periodistas, necesitamos cuantificar el "esfuerzo financiero" (ratio precio/renta) por distrito. Debemos formular preguntas incómodas para obtener datos verdaderos y objetivos de cómo se presenta no solo el mercado inmobiliario, sino los hogares madrileños. ¿Se han convertido los barrios de renta media en zonas de exclusión para los ciudadanos? ¿Dónde está el hogar madrileño medio? 

## Dataset
**Fuentes**
- Idealista (Kaggle): https://www.kaggle.com/datasets/fjcob1/idealista-madrid (`Datos.csv`).
- INE · Renta neta media por hogar (Madrid ciudad, distritos; 2023): https://www.ine.es/jaxiT3/Tabla.htm?t=31097 (`31097.csv`).
- INE · IPC (España): https://www.ine.es/prensa/ipc_tabla.htm (usamos diciembre 2024 = `+2.8%` y diciembre 2025 = `+2.9%` para ajustar 2023 → 2025).

**Scope**
- Madrid ciudad (distritos). En el dataset de Idealista, `zona` se mapea a `cod_distrito` (01–21) para poder hacer el JOIN con la tabla de renta del INE.

**Tamaños**
- Idealista original: `11826` filas × `14` columnas.
- Idealista limpio (selección/normalización): `11210` filas × `10` columnas.
- Dataset final unido (Idealista + INE): `11210` filas × `11` columnas (`df_final.csv` y tablas MySQL).

**Diccionario breve (dataset final)**
- `provincia`: provincia del anuncio.
- `zona`: distrito (en formato “slug”, p.ej. `barrio-de-salamanca`, `centro`, etc.).
- `titulo`: título del anuncio.
- `precio_actual`: precio de venta (EUR).
- `metros`: superficie (m²).
- `habitaciones`: número de habitaciones.
- `ascensor`: si tiene ascensor (`S` / `N`).
- `planta`: altura (p.ej. `BAJO`, `1ª`, ..., `20ª`).
- `baños`: número de baños.
- `cod_distrito`: código del distrito (01–21).
- `renta_neta_media_por_hogar`: renta neta media por hogar (INE 2023; en SQL se renombra a `rnmh_2023`).

## Notas sobre calidad del dato
- Selección de variables: se descartaron columnas que no aportaban al análisis en esta iteración (`PrecioAnterior`, `tags`, `descripcion`, `Enlace`, etc.).
- Nulos en Idealista (original): para conservar los `11826` anuncios, imputamos valores faltantes con propagación hacia atrás (`bfill`) en `planta`, `habitaciones` y `ascensor`.
- Unión Idealista + INE: `zona` se traduce a `cod_distrito` (mapeo manual) para poder unir con la renta (INE).
- Métricas por m²: en las queries que calculan `precio_actual / metros` se impone `metros > 0` para evitar divisiones por cero.
- Eliminación de los duplicados.


## Preguntas clave
**Hipótesis y preguntas operativas** (artefacto final: `mysql_ventamadrid.sql`):
- **H1**: diferencia de precio medio por m² entre pisos con y sin ascensor por zona.
  - **H1.1**: diferencia por tipología (habitaciones: 1 vs 2).
  - **H1.2**: diferencia por altura (`planta`).
- **H2**: zonas más/menos asequibles según la renta (proxy: `precio_medio / renta_media`).
- **H4**: años de renta íntegra necesarios para cubrir la entrada del `20%` del precio de venta.
- **H5**: índice de asequibilidad (proxy: `renta_media / precio_m2_medio`).

## Proceso de análisis 
1. Obtención e importación de datos de nuestras diferentes fuentes. 
2. Limpieza individualizada de nuestros datos en la plataforma Visual Studio con Python. 
3. Unión de ambos conjuntos de datos en uno solo. 
4. Conexión e importación a mySQL. 
5. Querys/llamadas de selección de datos según preguntas realizadas. 
6. Análisis de resultados. 
**Herramientas**
- Limpieza: Python (pandas) en `Limpieza_Madrid.ipynb`.
- Análisis: MySQL. Artefacto final: `mysql_ventamadrid.sql`.

## Resultados / Insights
- **H1 (Ascensor por zona)**: el Retiro y el Barrio de Salamanca presentan la mayor diferencia de precio, donde tener ascensor encarece el metro cuadrado en `2.154 €` y `1.939 €` respectivamente. Villaverde y Vicálvaro presentan las menores diferencias de toda la lista, con apenas `351 €` y `344 €` por metro cuadrado de diferencia respectivamente.
- **H1.1 (Ascensor por habitaciones)**: para pisos de dos habitaciones, la diferencia es de `2.945 €`, lo que sugiere que el ascensor se valora más según el tamaño de la vivienda. En los pisos de una sola habitación, la diferencia se reduce a `1.513 €`. Además, el precio medio de un piso de 1 habitación sin ascensor (`4.960 €`) es incluso más alto que el de 2 habitaciones sin ascensor (`4.543 €`).
- **H1.2 (Ascensor por planta)**: la presencia de ascensor es un factor determinante en el precio, cuya importancia se intensifica drásticamente a medida que aumenta la altura de la vivienda. Mientras que en los bajos la diferencia de precio es mínima (`1.267 €`), en una `14ª` planta la brecha alcanza su máximo de `5.696 €`, evidenciando que un piso alto sin ascensor pierde gran parte de su valor de mercado. Además, la ausencia de datos (NULL) en la mayoría de las plantas superiores a la `13ª` para viviendas sin ascensor refleja una realidad arquitectónica y normativa, donde el ascensor es prácticamente obligatorio en grandes alturas.
- **H2 (Asequibilidad: precio vs renta)**: Villaverde y Puente de Vallecas son las zonas más asequibles, ya que requieren invertir solo entre `5.34` y `5.55` años de renta íntegra para comprar una vivienda. Vicálvaro y Carabanchel son las zonas menos asequibles, con ratios extremos de `78.68` y `71.05`, lo que sugiere un desequilibrio total entre precios y rentas locales.
- **H4 (Entrada 20%)**: habría que destinar casi `8` años de renta para poder adquirir el `20%` de entrada de venta en el Barrio de Salamanca, unos `7` en Chamartín y unos `6.5` en Moncloa. Por el contrario, para un piso en Vallecas solo son tres cuartos de año, como en Villaverde y en Usera un año completo.
- **H5 (Índice renta / precio·m²)**: Ciudad Lineal por cada metro cuadrado paga `23` veces el metro cuadrado con su renta. Le siguen Moncloa y Hortaleza con un ratio del `17`. En el otro lado, tendríamos empatados Vicálvaro y Carabanchel, cuyo ratio es `1:1`. Después se situaría Barrio de Salamanca y Centro.

## Recomendaciones de negocio (lecturas periodísticas -interpretación-)
Lo que sigue es una intepretación periodística en base al contexto de negocio en el que se enmarca el proyecto; no es una derivación inmediata de los datos:
- El mercado inmobiliario madrileño presenta una fractura insalvable entre el valor de los activos y la capacidad adquisitiva real, donde el esfuerzo financiero para la compra varía de forma drástica según el código postal: mientras que en zonas como Salamanca o Chamartín la barrera de entrada (el 20% inicial) exige hasta 8 años de ahorro íntegro, en Vallecas o Villaverde este acceso se reduce a menos de un año, evidenciando una brecha de acumulación de capital casi imposible de cerrar para las rentas medias en distritos del norte. Esta dificultad se agrava en barrios como Vicálvaro y Carabanchel, que muestran una desconexión total con ratios de esfuerzo de hasta 78.68, lo que indica que, a pesar de no ser las zonas más caras en términos absolutos, la desproporción entre los precios de venta y los ingresos locales es la más severa de la capital, convirtiendo la propiedad en una meta inalcanzable para quienes dependen exclusivamente de su renta.
- La dualidad del mercado madrileño exige una estrategia diferenciada: mientras en el sur (Villaverde o Vallecas) la prioridad debe ser la compra inmediata debido a que la barrera de entrada es mínima y el retorno rápido, en zonas de desequilibrio extremo como Vicálvaro o Carabanchel la decisión inteligente es el alquiler para evitar el sobreprecio.
- El precio de barrios céntricos señala gentrificación, tal vez por presión turística en el ratio construido (renta/precio_m2): de 6 a 23 (Barrio de Salamanca vs Ciudad Lineal).

## Limitaciones y próximos pasos

- Se podría haber hecho análisis agregados más complejos porque el dataset proyectaba información de diversos ámbitos y con implicaciones sociales, políticas y económicas.
- Enriquecer el análisis con más datos sobre otros años para hacer hipótesis sobre agregaciones no contempladas en este proyecto.
- Enriquecer las recomendaciones de negocio con perspectivas periodísticas sobre la misma temática.

## Cómo replicar el proyecto
Instrucciones exactas (entorno, dependencias, y orden recomendado):
- Descargas de archivos `Datos.csv` y archivo `31097.csv`
- Creación de Script de SQL: creación de base de datos. 
- Notebook de exploración inicial y limpieza: `Limpieza_Madrid.ipynb`: pulsar `Run all`, introducir contraseña de conexión a mySQL.
- En el Script de SQL: `mysql_ventamadrid.sql`: seguir instrucciones y ejecutar querys. 
