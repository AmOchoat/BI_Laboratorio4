# Laboratorio 4 - Modelado multidimensional y ETL inicial

## Objetivos

- Entender las características de un proceso de ETL
- Definir un proceso de ETL
- Familiarizarse con herramientas específicas y de propósito general para realizar procesos de ETL 
- Identificar los subsistemas del proceso ETL en un caso práctico
- Crear y poblar modelos dimensionales 

## Herramientas

-  PosgreSQL
    - [Máquina virtual con pentaho BA ] 
        -  Nombre de usuario: isis
        -  Contraseña: Contraseña asignada.
    - Forma local. Pueden encontrar los instaladores en este enlace: https://www.postgresql.org/download/
-  Spoon que hace parte de Pentaho PDI (Data Integration), requiere tener java instalado. Pueden encontrar los instaladores en este enlace: https://sourceforge.net/projects/pentaho/
-  GoogleCloud - BigQuery


## Preparación 

- Solicitar su máquina virtual windows para tener acceso al software requerido en el proyecto
- Instalar localmente las herramientas descritas en la sección de herramientas.
    - Descargar Pentaho PDI (Data Integration). 
        - Obtener el software en este enlace: https://sourceforge.net/projects/pentaho/
    - Descargar e instalar PostgresSQL en su computador local. (Omita este paso si cuenta con conectividad con su máquina virtual y con acceso PostgreSQL). 

        - Obtener el software en este enlace: https://www.postgresql.org/download/ 

    - (Opcional) Descargar e instalar PgAdmin, manejador de PostgreSQL. Con esa herramienta se podrá conectar a la BD de su máquina virtual o de su máquina local. 

        - Obtener el software en este enlace: https://www.pgadmin.org/download/ 

- Descargar el archivo [CrearTablas.txt](Datos/CrearTablas.txt), que contiene los scripts necesarios para crear las diferentes tablas que requiere este laboratorio. 

- Descargar y descomprimir el archivo [Muestra.zip](Datos/Muestra.zip). Este archivo contiene una muestra de los datos en formato CSV, requeridos en este laboratorio. 

    > ***Bono1:*** Puede obtener una bonificación en este laboratorio si utiliza los [datos completos](Datos/DatosCompletos.zip) y realiza el proceso requerido de preparación para cargarlos de forma completa a la base de datos creada en este laboratorio. Dada la cantidad de datos, el proceso normal de carga no es apropiado. Revisa alternativas como: BulkLoad.  

 - Crear base de datos ROLAP en su máquina local o en la máquina virtual provista. Esta base se datos se hará utilizando PosgreSQL como manejador de base de datos. Este paso es equivale a crear un DataMart.
    * Iniciar el servicio de posgres
        > a.	En Windows ir a servicios
    
        > b.	Buscar el servicio local: posgresql-x64-14- PostgreSQL Server 14 (o su equivalente)

        > c.	Iniciar el servicio

    * Ejecutar pgAdmin para crear un usuario y una base de datos
    
        > a.	Crear un login para el curso llamado Isis, con clave (opción definition), con privilegios de login y de create databases (opción privileges)
        
        > b.	Crear la base de datos WWWIDW con owner Isis
        
        > c. Estos pasos puede hacerlos también desde la línea de comando de la siguiente manera:
            - Cree una nueva base de datos llamada WWWIDW.
        ```
        createdb WWWIDW
        ```
            - Asigne una contraseña al usuario isis de la base de datos WWWIDW (el usuario isis fue creado por defecto en esa base de datos).
        ```
        psql -W WWWIDW
         \password
        ```
    * Conectarse a la base de datos creada, con la aplicación psql y  utilizando los siguientes datos: 

      - Usuario: isis
      - password: password asignado al usuario en postgreSQL
      - host: localhost, o dirección IP de la máquina virtual.
      
      - Puede hacerlo desde windows y en ese caso los datos serán solicitados de forma interactiva, como se muestra en esta figura:
      ![figura](img/psql.PNG)
      - O también puede conectarse desde la línea de comando, con el siguiente comando para conectarse con psql, actualizando la dirección IP de la máquina virtual.
  
        ```
          psql -U isis -W WWWIDW
        ```
    
    * Más adelante en el laboratorio, una vez creada la base de datos y poblados los datos, puede explorar el esquema de la base de datos. Desde la máquina virtual utilice directamente el comando de \dt. 
  
        ```
        \dt public.*
        
        ```
    * Si observa las tablas y al consultarlas no aparece, es posible que su nombre por defecto tenga la primera letra en mayúscula, así que debe utilizar comillas en el nombre de la tabla y/ columnas para poder accederla.
        ```
        select * from "Date";
        
        ```

## Perfilamiento y preprocesamiento de los datos 

Los archivos CSV que se van a utilizar en este laboratorio provienen de una base de datos SQLServer, por lo que es importante realizar un perfilamiento de los archivos recibidos para limpiar o transformar datos que puedan generar conflictos en el proceso. 

La idea es que realice este proceso reutilizando lo trabajado en los notebook del módulo 1 del curso.

> ***Bono2:*** Puede obtener una bonificación en este laboratorio si integra el código python requerido para el preprocesamiento de los datos, 
    dentro del proceso completo de ETL. Esto aplica si su solución de ETL no es python. 

Nota: Tenga cuidado a la hora de eliminar filas de los archivos CSV puesto que pueden afectar las dependencias entre llaves foráneas existentes de la BD. 


## Enunciado

Este laboratorio tiene dos partes que son equivalentes y corresponden al uso de herramientas específicas para realizar procesos de ETL, o de propósito general, 
las cuales son respectivamente: 

1) Spoon de la suit de Pentaho y 
2) Google Cloud en especial a CloudStorage y BigQuery. 

Al final deben realizar una comparación de las herramientas de ETL propuestas, incluir el uso de una tercera herramienta, seleccionada por ustedes, y sacar sus conclusiones.
En la máquina virtual suministrada, al igual que en la sala waira está instalado Talend (https://www.talend.com/lp/open-studio-for-data-integration/), otra herramienta que podría ser útil como tercera herramienta. 
Sin embargo, son ustedes quienes deciden la tercera herramienta a incluir en el laboratorio.

## Caso de estudio

WWI (World Wide Importers) [^1] es una empresa encargada de realizar importaciones y venderlas a diferentes clientes en diferentes ciudades de Estados Unidos. Actualmente, la empresa se encuentra buscando servicios de consultoría de BI puesto que desean optimizar sus ganancias, pues consideran que algunos de sus productos no están generando las ganancias que deberían. También, están interesados en saber si hay otros factores que le impiden optimizar sus ganancias. Dado lo anterior, WWI lo contrata a usted para que realice una consultoría de BI, en particular en esta fase, para la creación de la base de datos, la carga de datos y unas consultas iniciales que permitan validar el proceso previo. En esta ocasión quiere que el trabajo lo realicen en grupos de máximo 3 estudiantes, con el fin de comparar dos herramientas que está evaluando para utilizar a futuro en procesos de ETL. 

[^1]: <httpshttps://docs.microsoft.com/es-es/sql/samples/wide-world-importers-what-is?view=sql-server-ver15>


Para esta etapa de la consultoría, la empresa requiere que usted implemente un proceso ETL que le permita extraer los datos de órdenes desde unos archivos CSV y almacenarlos en un modelo dimensional tal que les permita realizar análisis para mejorar entre otros elementos, su eficiencia operativa. 
A continuación, se presenta el modelo multidimensional que se desea obtener: 


![Modelo Dimensional esperado generado utilizando Power BI](img/modeloMultidimensional.png)


Es así, como al final de este laboratorio se espera contar con un proceso ETL que lea los archivos CSV provenientes de la base de datos del cliente (SQL Server) y realice todo el proceso necesario para cargarlos en una base de datos PostgreSQL, al modelo dimensional mostrado anteriormente. 
En la siguiente sección, se presenta un tutorial que explica la forma de crear y cargar a una tabla, datos provenientes de un archivo CSV, correspondiente a una dimensión del modelo multidimensional, para el caso de SPOON y de forma general, para el caso de Google Cloud Big Query, la forma de crear tablas y cargarlas con datos provenientes de archivos CSV. 
Los pasos presentados en el tutorial deben ser repetidos para construir y cargar cada una de las dimensiones y la tabla de hechos del modelo dimensional recomendado. 

Se debe tener en cuenta que a lo largo del tutorial se presentan una serie de preguntas, las cuales deben ser respondidas en el informe que se entrega asociado a este laboratorio. 


## A. Proceso relacionado con Spoon

Para lograr extraer, transformar y cargar los datos, es necesario realizar los siguientes pasos en Pentaho Spoon:

0.	Abrir Spoon. En Windows, debe dar clic derecho en el archivo `“spoon.bat”` ubicado en la carpeta `pdi-ce-<versión>/data-integration` y seleccionar la opción `“ejecutar como administrador”`.
Si tiene problemas puede consultar esta [guía de pentaho](pentaho-community-edition-installation-guide-for-windows-whitepaper.pdf). En caso de error, también puede intentar configurar la siguiente variable de ambiente: PENTAHO_DI_JAVA_OPTIONS con el valor -Xms1024m.

![Ejecutar Spoon](img/ejecutarSpoon.png)

1.	Crear un nuevo `“Job”` y guardarlo como `“job_dimensiones.kjb”`. 
 

2.	El proceso de ETL, requiere la conexión a la base de datos donde se crean y cargan las tablas que representan el modelo multidimensional diseñado, por lo cual se requiere conectarse a la base de datos de PostgreSQL. Para conectarse realice los siguientes pasos:
    - Seleccionar la pestaña `“View”`
    - Hacer clic en `Jobs > job_dimensiones > Database Connections`. 
    - Hacer clic derecho en `Database Connections` y seleccionar `New`.
    ![Crear conexión](img/crearConexion.png)
     
    - Llenar los campos con la información de su base de datos creada en PostgreSQL en el laboratorio anterior. 
        - Si la base de datos está en su máquina virtual, la dirección IP corresponde a la dirección IP de la máquina virtual. 
        - En caso de contar con la base de datos localmente, la dirección IP corresponde a “localhost”.
    ![Configurar la conexión](img/conexionBD.png)
 
    - Validar la conexión a la base de datos. Luego de llenar los campos con la información requerida, haga clic en el botón `“Test”`. 

    Si su conexión fue correcta, debe aparecer el siguiente mensaje (tenga en cuenta que `‘lab5_wwi’` es el nombre dado a la conexión, pero puede cambiar según el nombre que usted le asignó).
    
    ![Prueba de la conexión](img/testConexion.png)
 
    En caso de error, es posible que haya olvidado cambiar la clave de la base de datos creada en PosgreSQL.

    - Finalmente, para que pueda utilizar la conexión en todos los nodos relacionados con el Job, hacer clic derecho en la nueva conexión y seleccionar la opción `“Share”`.
 ![Compartir la conexión](img/compartirConexion.png)

3.	Para realizar tareas en Spoon es necesario utilizar nodos, cada uno con una función específica. Para comenzar un Job, arrastrar el nodo `“Start”` hacia el editor gráfico.
 ![Iniciar](img/start.png)	
 
Una de las tareas típicas en un proceso de ETL es ejecutar sentencias SQL sobre la base de datos como crear tablas, consultarlas o cargarlas, para realizar estas tareas debe utilizar el nodo `“SQL”`. Los pasos que requiere para seleccionar ese nodo y utilizarlo son los siguientes: 
    
    - Buscar y arrastrar el nodo `“SQL”` hacia el editor gráfico y ponerlo al lado derecho del nodo `“Start”`. 
    
    - Conectar los nodos para crear un flujo de ejecución:

        - Dejar presionado shift y dar clic izquierdo sobre el nodo `“Start”`
        - Dar clic sobre el nodo `“SQL”` y tendrá como resultado el siguiente modelo:
        
![Nodo SQL](img/nodoSQL.png) 


4.	Veamos un ejemplo de la forma de crear y poblar una tabla en Spoon: se va a crear la tabla que representa de la `dimensión Date`, para posteriormente llenarla con los datos del CSV correspondiente: `“dimensión_date.csv”`.
    - Crear la tabla Date
        - Abrir el nodo `SQL` y asignarle un nombre, por ejemplo `“SQL Date”`. 
        - En el campo `“Connection”` seleccionar la conexión con la BD Postgres que se creó en pasos anteriores. 
        - Llenar el campo `“SQL Script”` con el siguiente texto:

```
CREATE TABLE IF NOT EXISTS date_table(
Date_key DATE PRIMARY KEY,
Day_Number INT,
Day_val INT,
Month_val VARCHAR(20),
Short_Month VARCHAR(10),
Calendar_Month_Number INT,
Calendar_Year INT,
Fiscal_Month_Number INT,
Fiscal_Year INT);
```

        - Ejecutar el job, utilizando el triángulo de la parte superior. Esto le permitirá crear la tabla en la base de datos. Para validar la existencia de la tabla, puede consultar su pgAdmin y revisar las tablas de la base de datos WWWIDWLlenar el campo `“SQL Script”` con el siguiente texto:

### Preguntas
> - ¿Por qué se utiliza el comendo “IF NOT EXISTS” en la sentencia, en el contexto del proceso de ETL?
> - ¿Por qué para la columna de día se utiliza el nombre “day_val” y no “day”?
> - ¿De dónde se obtiene la información sobre las columnas que hay que crear en la tabla?

>***Nota:*** Tener en cuenta que la sentencia SQL que se escriba debe cumplir con el lenguaje de la BD destino, en este caso PostgreSQL. Le sugerimos probarlo primero directamente en la base de datos, luego borrar la tabla y una vez esté seguro de que la sentencia es correcta, incluirla en el nodo SQL.
    - Finalmente, guardar el nodo 

b.	Poblar la tabla Date

i.  Para poblar la tabla, se requiere de una transformación que tome los datos de los archivos “CSV” y lo utilice para llenar la tabla, para ello agregar a la derecha el nodo “Transformation”.
    ![Nodo transformation](img/nodoTransformacion.png)
 
> ¿Cuál es la diferencia entre un `“Job”` y una `“Transformación”` en Spoon?

ii.	Crear una transformación y asignarle un nombre, por ejemplo `“transformacion_date”`.

iii. Añadir el nodo `“CSV Input”` y configurarlo para que lea el archivo CSV que corresponde a la `dimensión Date`. Tener en cuenta que los parámetros del nodo dependen de las características del archivo CSV.

iv.	Para asegurarse de que lee bien el archivo CSV, al hacer clic en el botón `“Get Fields”` deben aparecer cada uno de los campos de la dimensión junto con el tipo de dato correcto. A continuación, un ejemplo:
![Ejemplo de catga de un archivo CVS](img/camposArchivo.png)
 
También, lo puede verificar utilizando la opción `“Preview”`.

• Agregar el nodo `“Insert/Update”` y conéctarlo con el lector CSV. Configurar el nuevo nodo para que se conecte correctamente con la BD destino y la tabla que va a ser poblada. Tenga en cuenta que el campo `“Target table”` debe ser llenado con el mismo nombre que le asignó a la tabla en el script SQL.
• En el campo `“The key(s) to lookup the values:”`, llenar el primer registro de tal forma que los campos correspondan a la llave del CSV y a llave de la tabla, como se muestra en el siguiente gráfico:
![Lookup](img/archivoBD.png)
 
• En el campo `“Update Fields”`, hacer clic en el botón `“Get update fields”`. Esta acción traerá todos los campos de la tabla. En caso de que algún nombre de columna no corresponda con el nombre esa columna en la tabla de PostgreSQL, actualizarlo manualmente. Luego de realizar este paso, la ventana deberá verse así:
![Update Fields](img/updateTabla.png)
 
	En el contexto del proceso ETL, 

    > ¿Por qué se hace uso del nodo `Insert/Update` y no del `Table Output`?
	> ¿Cuál es la finalidad de los campos `“The key(s) to lookup the values:”` y `“Update fields”` del nodo `Insert/Update`?


5.	Terminar el flujo de creación y carga de la tabla.
    - Volver al job_dimensiones y editar el nodo Transformation para que el campo `“Transformation”` apunte al archivo de la transformación que acabó de crear.
    
    - Ejecutar el job modelo (Use el triángulo superior), y si todo se ejecuta de manera correcta debe verse de la siguiente manera: 
    ![Ejecutar el job](img/ejecutarJob.png)
 

En donde, no deberán aparecer íconos de error, ni errores en consola. Tener en cuenta que el modelo debe poder ser ejecutado de nuevo y no generar errores por intento de “reinserción” de datos.

    > ¿Será posible programar la fecha y hora en la cual la organización puede correr de forma automática el proceso de ETL`?

RECOMENDACIONES
    - Luego de completar satisfactoriamente la lectura y carga de cada una de las dimensiones, asegurarse de que los datos se cargaron correctamente realizando una consulta SQL hacia la base de datos. Utilizando pgAdmin, o cualquier otro software de manejo de bases de datos, es posible realizar estas consultas de manera sencilla. A continuación, un ejemplo de consulta sobre la tabla Date utilizando pgAdmin:
    ![PgAdmin](img/pgAdmin.png)
    - Para completar el proceso ETL, se debe iterar sobre los pasos realizados en el tutorial, aplicándolos a cada una de las dimensiones restantes y a la tabla de hechos. Tenga en cuenta que, si alguna tabla cuenta con llaves foráneas, en especial la tabla de hechos, el orden en que se creen las tablas y carguen los datos influirá en el proceso. Se recomienda realizar el proceso en un Job que secuencialmente llene las tablas de las dimensiones y, finalmente, llene la tabla de hechos. A continuación, un modelo de ejemplo:
    ![Proceso completo de ETL](img/cargaCompleta.png)
 

6.	ACTIVIDADES
    - Completar el proceso de tal forma que cumpla con el modelo dimensional propuesto. Para finalmente probar que su modelo cargó los datos correctamente, conectarse directamente a la base de datos PosgtreSQL y realizar consultas sobre las tablas creadas.
    - Finalmente, realizar consultas sobre la base de datos para garantizar que la información fue cargada.
 


## B. Proceso relacionado con herramientas de Google Cloud

### Preparación
-	Esta parte del laboratorio será realizado con tecnologías CLOUD (Google Cloud Platform), así que es necesario tener o crear una cuenta de Google. Puede usarse una cuenta por grupo.
-	Las tecnologías que se usarán no tienen costo alguno en Google Cloud Platform, por lo que no es necesario que ingrese información de pago en la plataforma.
-	Se trabajará con BigQuery y Google Cloud Storage, unas herramientas poderosas para carga de información y consultas analíticas.


## Tutorial para utilizar las herramientas
- Ingrese a la plataforma de google cloud en este [enlace](https://cloud.google.com/?utm_source=google&utm_medium=cpc&utm_campaign=latam-CO-all-es-dr-BKWS-all-all-trial-e-dr-1009133-LUAC0010194&utm_content=text-ad-none-any-DEV_c-CRE_452834960535-ADGP_BKWS%20%7C%20Multi%20~%20Google%20Cloud%20Platform-KWID_43700047166266614-kwd-301173107504&utm_term=KW_google%20cloud%20platform-ST_Google%20Cloud%20Platform&gclid=EAIaIQobChMIyfLSq6nB7AIVBjiGCh2Inw95EAAYASAAEgJy5vD_BwE&gclsrc=aw.ds)
 ![Plataforma Google Cloud](img/inicioGC.png)
- Una vez ahí, hacer clic en “Acceder” en la parte superior derecha. El usuario de acceso, debe ser una cuenta a la que todo el grupo tenga acceso. 
- Los archivos deben ser cargados directamente en el momento de crear las tablas.

Una vez autenticados dar clic en “Consola” en la parte superior derecha.
![Acceder](img/acceder.png)

- En el buscador de la plataforma ingresar “BigQuery” y elegir el producto que aparece.
 ![Buscar BigQuery](img/buscarBQ.png)
A continuación, dar clic sobre “CREAR PROYECTO”
 ![Crear un proyecto](img/crearProyecto.png)
El nombre del proyecto es de libre elección, pero es vital que no cambien la ubicación 
 ![Nuevo proyecto](img/nuevoProyecto.png)

- Una vez se cree el proyecto, debe aparecer la siguiente pantalla. En la parte lateral izquierda de la pantalla, encuentran un menú, y en la sección de Recursos encuentran el proyecto vacío. Lo siguiente a hacer es crear un conjunto de datos para ese recurso, para esto dar clic en el recuso seguido de “CREAR CONJUNTO DE DATOS”  
![Crear un conjunto de datos](img/BigQuery/crearConjuntoDatos.png)

- El ID del conjunto es de libre elección, se sugiere dejar las configuraciones por defecto 
![Asignar detalles al conjunto de datos](img/BigQuery/crearConjuntoDatosDetail.png)

- Cuando se cree el conjunto de datos, seleccione los tres puntos en el panel de la izquierda, y oprima la opción abrir.
![Abrir conjunto de datos](img/BigQuery/abrirConjuntoDatos.png)

- Para crear una tabla en ese conjunto deben  dar clic en el boton "+ Crear tabla” en la parte superior. 
![Crear tabla](img/BigQuery/crearTabla.png)

- Se abrirá un panel a la derecha. Allí, elija en el primer campo "Subir". Esto le permitirá agregar a la herramienta los csv que descargó en el laboratorio.
![Elegir fuente de una tabla](img/BigQuery/elegirFuenteTabla.png)

- Elija un nombre para la tabla y seleccione la opción "Detección  automática: Esquema y parámetros de entrada."
![Crear tabla detail](img/BigQuery/crearTablaDetail.png)

- Una vez creada la tabla, puede abrirla seleccionando los tres puntos que aparecen en su nombre (ubicado en el panel izquierdo). 
![Abrir tabla](img/BigQuery/abrirTabla.png)

- AL abrir la tabla, se mostrará información útil de sus atributos. Revise que las columnas tengan el tipo adecuado. Si desea realizar una consulta sobre dicha tabla, seleccione el boton "Consulta" en la parte superior derecha.
![Detail de tabla](img/BigQuery/tablaDetail.png)

- Para ejecutar una consulta se da clic en el botón ”Ejecutar”. Los resultados de dicha consulta se abrirán en un panel en la parte inferior. 
![Editor de consultas](img/BigQuery/consultaTabla.png)

- Si desea guardar alguna consulta, como tabla intermedia o ya exportarlo a CSV, puede hacerlo seleccionando "Guardar los resultados" en el panel inferior (donde aparecen los resultados de la consulta)
![Guardar consultas](img/BigQuery/guardarConsulta.png)

- Allí, podrá seleccionar cómo desea guardar la tabla.
![Guardar consultas detail](img/BigQuery/guardarConsultaDetail.png)

- El proceso de carga debe hacerse para todo el modelo del laboratorio, una vez finalizado este proceso el conjunto de datos (con todas las tablas respectivas) debe estar listado en la parte inferior izquierda.  
![Conjunto de datos y tablas creadas](img/informacionConjunto.png)

- Con el fin de construir el modelo multidimensional recomendado para el caso, se sugiere cargar los archivos a unas primeras tablas, con una estructura equivalente a los archivos CSV y, luego realizar consultas sobre esas tablas temporales para generar el contenido que debe quedar en las tablas definitivas que representan el modelo.  Recuerda validar que se respetan las restricciones de llave foránea, en particular sobre la tabla de fact_orders.

- Si tienen problemas para acceder a los datos cargados en GoogleBigQuery es posible que los haya cargado al drive, la propuesta es cargar directamente los archivos al momento de crea una tabla.


## Instrucciones de Entrega
- El laboratorio se entrega en grupos de máximo 3 estudiantes
- Recuerde hacer la entrega por la sección unificada en Bloque Neón, antes del sábado 6 de noviembre a las 22:00.   
  Este será el único medio por el cual se recibirán entregas.

## Entregables

- Diagrama de alto nivel describiendo el proceso de ETL. Apoyarse en las lecturas del curso, donde está descrito en detalle sste punto.
- Documentación de las transformaciones realizadas. 
- Transformaciones y jobs definidos en pentaho PDI (o su equivalente si utilizaron otras herramientas). 
- Resultados que demuestren una implementación adecuada para cada herramienta utilizada, ejecución correcta del ETL y evidencia de los modelos dimensionales poblados. Setencias sql utilizadas para consultar la información de dimensiones y tablas de hecho y mostrar unos registros que dan como resultado de la ejecución de las consultas.
- Comparación de las tres herramientas de ETL.
- Respuestas a las preguntas incluidas a lo largo del enunciado del laboratorio
- Recuerden que es importante la evidencia del proceso realizado y la ejecución correcta de lo construido. Estos elementos serán considerados en la evaluación sumativa del curso.

## Rúbrica de Calificación

A continuación se encuentra la rúbrica de calificación.

**Nota:** Los siguientes porcentajes hacen referencia a la nota grupal, que corresponde a un 80% de la nota inidividual.  
El 20% restante se calcula según el puntaje obtenido en el proceso ETL utilizando una herramienta, del cual el estudiante estuvo a cargo dentro del grupo.

| Concepto | Porcentaje |
|:---:|:---:|
| Diagrama de alto nivel describiendo el proceso de ETL | 8% |
| Documentación del proceso y las transformaciones realizadas - Modificaciones a los esquemas en Spoon  | 13% |
| Documentación del proceso y las transformaciones realizadas - Modificaciones a los esquemas en BigQuery| 13% |
| Documentación del proceso y las transformaciones realizadas - Modificaciones a los esquemas en la 3era herramienta| 13% |
| Resultados que demuestran una implementación adecuada para Spoon, ejecucición correcta del ETL con evidencia de las tablas cargadas con este proceso | 10% |
| Resultados que demuestran una implementación adecuada para BigQuery, ejecucición correcta del ETL  con evidencia de las tablas cargadas con este proceso| 10% |
| Resultados que demuestran una implementación adecuada para la 3era herramienta, ejecucición correcta del ETL con evidencia de las tablas cargadas con este proceso| 10% |
| Respuestas a las preguntas del laboratorio | 10% |
| Comparación de las herramientas de ETL | 13% |


## Sugerencias

- Use la máquina virtual que le asignó admonsis para el curso. En dicha máquina, encuentra instalado pdi y en particular Spoon. 
- Es posible que tenga problemas al acceder alguno de los archivos "csv". Esto puede ser porque tiene insalado el software en un directorio de red y no en un directorio local. Asegúrese que está utilizando la versión de JAVA correcta, JAVA_HOME debe estar apuntando a una versión de java de 64bits. Deben ejecutar el archivo Spoon.bat
- En las salas Waira, Pentaho Data Integration está instalado en `C:/Software/data-integration`.

## Referencias
- https://wiki.pentaho.com/display/EAIes/Manual+del+Usuario+de+Spoon
- https://cloud.google.com/solutions/performing-etl-from-relational-database-into-bigquery?hl=it
- [3] Capítulo 20 (desde pág. 512 hasta pág. 520). - [3] KIMBALL, Ralph, ROSS, Margy. “The Data Warehouse Toolkit: the definitive guide to dimensional modeling".  Third Edition.  John Wiley & Sons, Inc, 2013.
- Opc. [6] Capítulo 11 (págs. 464-472) - [6] KIMBALL, Ralph, ROSS, Margy, BECKER, Bob, MUNDY Joy, and THORNTHWAITE, Warren. "The Kimball Group Reader: Relentlessly Practical Tools for Data Warehousing and Business Intelligence Remastered Collection". Wiley, 2016 
