
# SE VENDE MADRID
** Juan José Ruiz ** 
** Carmen Ríos Rodríguez ** 

## Objetivo
Este análisis busca desvelar la brecha entre el precio de mercado de los inmuebles vendidos y la capacidad económica real de los hogares madrileños. Investigamos si existe una correlación directa entre la renta neta media y el acceso a la propiedad, o si factores externos (especulación, turismo) están rompiendo el equilibrio habitacional de la capital.

## Contexto de negocio 
Madrid enfrenta una escalada de precios que parece desconectada de los salarios locales así que creemos que, como periodistas, necesitamos cuantificar el "esfuerzo financiero" (ratio precio/renta) por distrito. Debemos formular preguntas incómodas para obtener datos verdaderos y objetivos de cómo se presenta no solo el mercado inmobiliario, sino los hogares madrileños. ¿Se han convertido los barrios de renta media en zonas de exclusión para los ciudadanos? ¿Dónde está el hogar madrileño medio? 

## Dataset
En primer lugar, nuestra fuente es una tabla csv de keggle de los precios de idealista por barrios de Madrid. Las variables recogidas agrupan: zona y distrito de madrid, número de habitaciones, si tiene ascensor, planta y precio. 
En segundo lugar, hemos importado una tabla por distrito madrileño de la renta neta media por hogar en el 2023 del Instituto Nacional de Estadística. Las variables son distrito y renta neta media por hogar. 
Por último, para un benchmark más realista, investigamos en la misma fuente el porcentaje de iflación por hogar: url = https://www.ine.es/prensa/ipc_tabla.htm con el que realizamos el álculo para acercarlo a lo más posible al momento actual. 


## Preguntas clave
* ¿En qué zonas ha crecido más el precio de venta? (Idea original)
* ¿Dónde es más asequible comprar un piso según la renta? ¿Dónde menos? 
* ¿Cuál es la diferencia de precio entre pisos con y sin ascensor? ¿Y según habitaciones? ¿Y por plantas?
* ¿Cuántos años de renta íntegra (100% del salario sin gastar en nada más) se necesitan para pagar la entrada (20% del precio) en cada distrito?
* Índice de asequibilidad: renta/precio x m2 

## Proceso de análisis 
1. Obtención e importación de datos de nuestras diferentes fuentes. 
2. Limpieza individualizada de nuestros datos en la plataforma Visual Studio con Python. 
3. Unión de ambos conjuntos de datos en uno solo. 
4. Conexión e importación a mySQL. 
5. Querys/llamadas de selección de datos según preguntas realizadas. 
6. Análisis de resultados. 

## Hallazgos más importantes 
El Retiro y el Barrio de Salamanca presentan la mayor diferencia de precio, 
donde tener ascensor encarece el metro cuadrado en 2.154 € y 1.939 € respectivamente.
Villaverde y Vicálvaro presentan las menores diferencias de toda la lista, con apenas 351 € y 344 € por metro cuadrado de diferencia respectivamente.
Para pisos de dos habitaciones, la diferencia es de 2945€, lo que sugiere que el ascensor se valora más según el tamaño de la vivienda. En los pisos de una sola habitación, la diferencia se reduce a 1513€. 
Además, el precio medio de un piso de 1 habitación sin ascensor (4960€) es incluso más alto que el de 2 habitaciones sin ascensor (4543€). 
La presencia de ascensor es un factor determinante en el precio, cuya importancia se intensifica drásticamente a medida que aumenta la altura de la vivienda. 
Mientras que en los bajos la diferencia de precio es mínima (1267€), en una 14ª planta la brecha alcanza su máximo de 5696€, evidenciando que un piso alto sin ascensor pierde gran parte de su valor de mercado.
Además, a ausencia de datos (NULL) en la mayoría de las plantas superiores a la 13ª para viviendas sin ascensor refleja una realidad arquitectónica y normativa, donde el ascensor es prácticamente obligatoria en grandes alturas.
Villaverde y Puente de Vallecas son las zonas más asequibles, ya que requieren invertir solo entre 5.34 y 5.55 años de renta íntegra para comprar una vivienda. Vicálvaro y Carabanchel son las zonas menos asequibles, con ratios extremos de 78.68 y 70.05, lo que sugiere un desequilibrio total entre precios y rentas locales.
Habría que destinar casi 8 años de renta para poder adquirir el 20% de entrada de venta en el Barrio de Salamanca, unos 7 en Chamartín y unos 6 y medio en Moncloa. Por el contrario, para un piso en Vallecas solo son tres cuartos de año, como en Villaverde y en Usera un año completo.
Ciudad lineal por cada metro cuadrado paga 23 veces el metro cuadrado con su renta. Seguido de Moncloa y Hortaleza con un ratio del 17. En el otro lado, tendríamos empatados vicalvaro y Carabanchel, cuyo ratio es 1:1. Después se situaría Barrio de Salamanca y Centro.

## Conclusiones y recomendaciones
El mercado inmobiliario madrileño presenta una fractura insalvable entre el valor de los activos y la capacidad adquisitiva real, donde el esfuerzo financiero para la compra varía de forma drástica según el código postal: mientras que en zonas como Salamanca o Chamartín la barrera de entrada (el 20% inicial) exige hasta 8 años de ahorro íntegro, en Vallecas o Villaverde este acceso se reduce a menos de un año, evidenciando una brecha de acumulación de capital casi imposible de cerrar para las rentas medias en distritos del norte. Esta dificultad se agrava en barrios como Vicálvaro y Carabanchel, que muestran una desconexión total con ratios de esfuerzo de hasta 78.68, lo que indica que, a pesar de no ser las zonas más caras en términos absolutos, la desproporción entre los precios de venta y los ingresos locales es la más severa de la capital, convirtiendo la propiedad en una meta inalcanzable para quienes dependen exclusivamente de su renta.
La dualidad del mercado madrileño exige una estrategia diferenciada: mientras en el sur (Villaverde o Vallecas) la prioridad debe ser la compra inmediata debido a que la barrera de entrada es mínima y el retorno rápido, en zonas de desequilibrio extremo como Vicálvaro o Carabanchel la decisión inteligente es el alquiler para evitar el sobreprecio.

## Limitaciones y próximos pasos

Podríamos haber hecho querys porque hay mucha más información 
Podríamos añadir más datos sobre otros años para hacer un análisis más rico 
Podríams haber enriquecido el análisis con perspectivas periodísticas sobre la misma temática 

## Cómo replicar el proyecto
Instrucciones exactas (entorno, dependencias, y orden recomendado):
- Descargas de archivos `Datos.csv` y archivo `31097.csv`
- Creación de Script de SQL: creación de base de datos. 
- Notebook de exploración inicial y limpieza: `Limpieza_Madrid.ipynb`: pulsar `Run all`, introducir contraseña de conexión a mySQL.
- En el Script de SQL: `mysql_ventamadrid.sql`: seguir instrucciones y ejecutar querys. 