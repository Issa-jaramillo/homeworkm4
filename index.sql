/* Para dar formato en la SQL shell */
\pset format aligned
\pset border 2
/* Algunos comandos */
\l → listar las db

CREATE DATABASE prueba; → importante el ; 

\l
\c prueba --> para conectarme a la db prueba
\dt para mostrar el detalle de la db

CREATE TABLE ciudades 
( id serial PRIMARY KEY,
nombre varchar(255) UNIQUE
);

CREATE TABLE personas
( id serial PRIMARY KEY
nombre varchar ( 255 ) UNIQUE,
apellido varchar ( 255 ) NOT NULL,
ciudad integer references ciudades ( id )
);

\dt
// Deben pasarse con comillas simples
INSERT INTO ciudades (nombre) VALUES ('Bogota'), ('Medellin'), ('Cali');

SELECT * FROM ciudades;

INSERT INTO personas (nombre, apellido, ciudad) VALUES ('Feli','Ciro',2), ('Juan','Perez',1), ('Camilo','Aristizabal',3);

// Si le pasamos un insert de personas sin el apellido, rompe porque es not null

INSERT INTO personas (nombre) VALUES ('Jose');

En este caso el id se incremento aunque no se guardo el registro
Tiene sentido que si habian 500 personas viviendo en una ciudad y se borra el registro de esa ciudad, no se agregue una nueva con el mismo id, ya que esto llevaria a que las personas pasen a vivir a esa nueva ciudad

SELECT nombre FROM personas; --> trae toda la info solo de la columna nombre
SELECT DISTINCT nombre FROM personas; --> trae toda la info de la columna sin repetidos
SELECT nombre, apellido FROM personas;
SELECT * FROM personas WHERE ciudad = 2;

// Para usar comparativos
INSERT INTO personas (nombre, apellido) VALUES ('Maria','Bedoya');
Select * from personas WHERE ciudad = null; --> esta forma no
Select * from personas WHERE ciudad is null; --> esta forma si
// Para ordenar
Select * from personas ORDER BY ciudad; -> por defecto es ascendente
Select * from personas ORDER BY ciudad DESC; --> descendente

// vamos con operadores
CREATE TABLE empleados
( id serial PRIMARY KEY,
name varchar ( 25 ),
age integer ,
address varchar ( 25 ),
salary integer
);

// Llenando la tabla
INSERT INTO empleados (name, age, address, salary) VALUES 
('Feli',25,'Colombia',10),
('Juan',32,'Argentina',100),
('Ricardo',21,'Chile',50),
('Laura',47,'Chile',60);

// haciendo la consulta
SELECT address, SUM(salary) FROM empleados GROUP BY address; --> debe seleccionar la misma entidad con la que se agrupa
// otra consulta usando count

Select address, COUNT(*) FROM empleados GROUP BY address;
Select address, COUNT(CASE WHEN age > 30 THEN 1 END) FROM empleados GROUP BY address;

// otra con avg -> promedio
SELECT AVG(salary) FROM empleados;

// SUBQUERIES
SELECT * FROM empleados WHERE salary > (SELECT AVG(salary) FROM empleados);

// JOIN
SELECT * FROM personas JOIN ciudades ON ciudades.id = personas.ciudad; --> trae todos los campos de ambas tablas
SELECT personas.nombre, apellido, ciudades.nombre FROM personas JOIN ciudades ON ciudades.id = personas.ciudad; --> trae los campos que le especifico, pero nombre como columna se repite
SELECT personas.nombre, apellido, ciudades.nombre AS ciudad FROM personas JOIN ciudades ON ciudades.id = personas.ciudad; --> Se soluciona dandole un alias
// Se le puede dar incluso alias a las tablas
SELECT apellido, p.nombre, c.nombre AS ciudad FROM personas AS p JOIN ciudades AS c ON c.id = p.ciudad;
SELECT apellido, p.nombre, c.nombre AS ciudad FROM personas AS p LEFT JOIN ciudades AS c ON c.id = p.ciudad; --> Trae las personas que tienen y no tienen ciudad
SELECT apellido, p.nombre, c.nombre AS ciudad FROM personas AS p RIGHT JOIN ciudades AS c ON c.id = p.ciudad; --> Trae las ciudades que tienen y no tienen personas asociadas
SELECT apellido, p.nombre, c.nombre AS ciudad FROM personas AS p FULL OUTER JOIN ciudades AS c ON c.id = p.ciudad; --> trae una combinacion de las dos anteriores

// Finalmente unos matchers
SELECT * FROM personas WHERE apellido LIKE '%r%'; --> el porcentaje significa que hay mas texto, en este caso buscamos una r enmedio de una palabra
SELECT * FROM personas WHERE apellido ILIKE '%R%'; --> En este caso decimos que no importa el case sensitive