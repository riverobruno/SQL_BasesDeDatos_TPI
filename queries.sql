
-- 1) Listado de docentes que viven en una provincia distinta de aquella en la que trabajan. 
SELECT distinct r.dni,r.nombres, r.Apellido
FROM  docentes r, Localizaciones l,(SELECT l1.provincia, a.docente
FROM Actividades_univ a, Dependencias_univ d1, Localizaciones l1
WHERE a.lugar_trab=d1.id AND d1.codciu=l1.codigo)as temporal
WHERE r.codciu=l.codigo and r.dni= temporal.docente
AND l.provincia<>temporal.provincia 
ORDER BY r.dni
;

-- 2) Listado de docentes que poseen títulos de posgrado y no realizan tareas de investigación. 
SELECT DISTINCT p.docente, d.nombres,d.Apellido
FROM  docentes d INNER JOIN (pertenecen p INNER JOIN titulos t ON p.nombre=t.nombre)on d.dni=p.docente
WHERE t.nivel LIKE '%posgrado%' AND p.docente NOT IN
(SELECT d.dni FROM Docentes d, Realizan r
WHERE d.dni=r.docente);

-- 3) Informar promedio de edad de los docentes que poseen más de 10 años de antecedentes como docentes. 
SELECT AVG (timestampdiff(year,d.fecha_nac,curdate())) as promedio
FROM
(SELECT au.docente, sum(timestampdiff(year, a.f_ingreso, a.fecha_sal)) AS antecedentes
FROM Actividades_Univ au NATURAL JOIN Actividades a
WHERE a.cargo LIKE '%profesor%'
GROUP BY au.docente
HAVING antecedentes>10) AS c NATURAL JOIN Docentes d;
;

-- 4) Listar DNI y nombre de los docentes que presentaron más de un cargo docente en las declaraciones juradas de los últimos 3 años 
SELECT d.dni, d.nombres,d.Apellido
FROM
(SELECT de.docente, COUNT(id_activ) AS cant_unv
FROM Declaran de NATURAL JOIN Actividades au
WHERE de.añofirma between 2022 and 2024 and au.cargo like '%profesor%'
GROUP BY de.docente
HAVING cant_unv>1) as b inner JOIN Docentes d on d.dni=b.docente
;

-- 5) Listado de docentes cuya carga horaria supera las 20 horas semanales, en función de la última declaración jurada presentada. 
SELECT d.dni, d.nombres, d.Apellido,b.añofirma,b.horas_semana
FROM
(SELECT au.docente, de.añofirma,SUM(ABS(timestampdiff(hour, hora_ent, hora_sal))) as horas_semana
FROM Actividades_Univ au INNER JOIN Contemplan c ON au.id_activ= c.id_activuniv INNER JOIN Horarios h ON c.id_horario=h.id
INNER JOIN Declaran de on au.id_activ= de.id_activ
WHERE de.añofirma=2024
GROUP BY au.docente,de.añofirma
HAVING horas_semana>20) as b INNER JOIN Docentes d on b.docente=d.dni
;
-- 6) Apellido y nombre de aquellos docentes que poseen la máxima cantidad de cargos docentes actualmente. (La cantidad de cargos surge de sumar todos los cargos docentes que se ejercen - suma de cargos docentes de la última declaración jurada -. Una vez que se sabe la cantidad de cargos por docente se puede averiguar cuál es la máxima cantidad y seguidamente los docentes que tienen esa máxima cantidad). No nos interesa las horas. 
SELECT d.nombres, d.Apellido, temp.cant_act 
FROM Docentes d inner JOIN(SELECT de.docente, COUNT(id_activ) as cant_act
							FROM Declaran de NATURAL JOIN Actividades au
							WHERE de.añofirma= YEAR(curdate()) AND au.cargo like '%profesor%' 
                            GROUP BY de.docente
                            having cant_act=(SELECT MAX(b.cant_act)
												FROM (SELECT dec1.docente, COUNT(id_activ) as cant_act
														FROM Declaran dec1 natural JOIN Actividades au1 
														WHERE dec1.añofirma= YEAR(curdate()) and au1.cargo like '%profesor%' 
														GROUP BY dec1.docente) as b)) as temp on d.dni=temp.docente
;
-- 7) Listado de docentes solteros/as (sin esposa/o e/o hijos a cargo en la obra social). 
SELECT d.dni, d.nombres, d.Apellido
FROM Docentes d
WHERE d.dni NOT IN (SELECT ap.docente 
					FROM Alcanzado_por ap)
;

-- 8) Cantidad de docentes cuyos hijos a cargo son todos menores de 10 años. 
SELECT COUNT(d.dni)
FROM Docentes d
WHERE NOT EXISTS ( SELECT ap.familiar
FROM Alcanzado_por ap INNER JOIN Familiares f ON ap.familiar=f.documento
WHERE ap.parentesco LIKE '%hijo%' AND ap.docente=d.dni
EXCEPT
SELECT ap.familiar
FROM Alcanzado_por ap INNER JOIN Familiares f ON ap.familiar=f.documento
WHERE ap.parentesco LIKE '%hijo%' AND ap.docente=d.dni
AND TIMESTAMPDIFF(year, fecha_nac,  curdate()) < 10)
;

-- 9) Informar aquellos docentes que posean alguna persona del grupo familiar a cargo en la obra social que no es beneficiario del seguro de vida obligatorio. 
SELECT DISTINCT d.dni, d.nombres, d.apellido
FROM Docentes d, familiares f
WHERE EXISTS      (SELECT ap.docente,ap.familiar
FROM Alcanzado_por ap
WHERE ap.docente=d.dni and ap.familiar=f.documento 
EXCEPT
SELECT sb.familiar,sb.docente
FROM Se_Beneficia sb
WHERE sb.docente= d.dni and sb.familiar=f.documento)
;

-- 10) Informar Cantidad de individuos asegurados por provincia.  
SELECT temp.provincia, COUNT(temp.docente) AS cantdocentes
FROM (SELECT l.provincia, s.docente 
	FROM Seguros s, docentes d, Localizaciones l 
    WHERE d.dni=s.docente AND l.codigo=d.codciu) AS temp
GROUP BY temp.provincia







