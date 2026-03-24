use empresa_dam;
/*6. Crea una función que reciba el número de un departamento y devuelva un número real que indique
el porcentaje que supone la suma de los salarios de los empleados de ese departamento en relación
con la suma salarial de todos los empleados de la empresa.*/
select Salario, NumDep
from empleado 
where NumDep = 1;

select SUM(Salario) as sumSalario
from empleado
where NumDep = 1
group by NumDep;

select SUM(Salario)
from empleado;

Delimiter //
create function porSalarioDep(dep int) returns int reads sql data
begin
declare salDep int;
declare salALL int;
declare percent int;    
select sum(Salario) into salDep
	from empleado
    where NumDep = dep
    group by NumDep;
    
select sum(Salario) into salALL
	from empleado;
set percent = (salDep/salALL)*100;
return percent;
end; //
    
select porSalarioDep(1);

/*7. Crea un procedimiento que reciba el nombre de un departamento y su localidad. Se debe insertar
ese departamento en la tabla Departamento asignándole como número el que resulte de sumar 1
al número más alto de los departamentos de la empresa. Escribe el final un mensaje con el formato
‘Departamento no xx añadido’, siendo xx el número asignado al nuevo departamento.*/

select max(NumDep)
from departamento;

Delimiter //
create procedure insertDep(nombre varchar(40), localidad varchar(40))
begin
declare depAsigned int;
select max(NumDep) into depAsigned
	from departamento;

insert into departamento
values (depAsigned+1, nombre, localidad);
select concat ('Departamento numero ',depAsigned+1, ' añadido') mensaje;
end;// 

call insertDep('Relaciones Publicas', 'Sevilla');

/*8. Escribe una función que reciba el número de un empleado de la tabla Empleado y que devuelva
el número de subordinados que tiene ese empleado, o lo que es lo mismo, el número de empleados
de los cuales es director o jefe directo. Recuerda que el atributo NumEmpJefe de la tabla Empleado
indica el número del empleado director o jefe directo. Escribe un ejemplo de llamada a la función.*/

select count(NumEmp)
	from empleado
    where NumEmpJefe = 1;
    
Delimiter //
create function Employee(jefe int) returns int reads sql data
begin
declare cantEmp int;
select count(NumEmp) into cantEmp
	from empleado
    where NumEmpJefe = jefe;
return cantEmp;
end;//

select Employee(4) CantidadEmpleados;

/*9. Crea un procedimiento llamado ModificarSalariosDep que reciba el número de un departamento
y un número real con dos decimales. El procedimiento, en primer lugar, obtendrá el número de
empleados que trabajan en el departamento cuyo número se ha recibido como primer parámetro.
En caso de que no trabaje ningún empleado en dicho departamento, se mostrará el mensaje “En
el dpto. no xxx no trabaja ningún empleado”. En caso contrario, se deberá modificar el salario de
los empleados del departamento cuyo número se ha pasado como primer parámetro en base al
porcentaje recibido como segundo parámetro, después de lo cual se mostrará el mensaje “Se ha
modificado el salario de todos los empleados del dpto. no xx en un yyy,yy%”.  */

select count(NumDep) CantidadEmpDep
from empleado
where NumDep = 3;

select Salario
from empleado
where NumDep = 3;

update empleado2
set Salario= (Salario*0.025)+Salario 
where NumDep= 1; 

Delimiter //
create procedure ModificarSalariosDep(departamento int, aumento numeric(6,2)) 
begin
declare CantidadEmpDep int;
select count(NumDep) into CantidadEmpDep
	from empleado
	where NumDep = departamento;
    
if CantidadEmpDep = 0 then
	select concat('El departamento numero ', departamento, ' no tiene empleados') MensajeSinEmp;
else 
	update empleado2
	set Salario= (Salario*aumento)+Salario 
	where NumDep= departamento; 
	select concat('Se ha modificado el salario de todos los empleados del departamento ', departamento, ' en un ', aumento, ' %') MensajeConEmp;
end if;
end; //

call ModificarSalariosDep(1, 5.25); //

/*10. Crea un procedimiento llamado AsignarComision que reciba un número de empleado y
compruebe su salario en la tabla Empleado. Si el salario del empleado es menor que 1500 €, se le
debe asignar una comisión que será el 5% del salario; en caso de que su salario sea superior o
igual a 1500 €, pero inferior a 2500 €, se le deberá asignar una comisión igual al 2,5% del salario;
en caso de que cobre 2500 € o más, se le pondrá a 0 € la comisión. Muestra un mensaje como el
siguiente: “Al empleado no XXXX se le ha asignado una comisión de YY.YY €”.*/

delimiter //
create procedure AsignarComision(NumeroEmp int)
begin
declare SalarioEmp decimal(6,2);
declare ComisionFinal decimal(6,2);
select Salario into SalarioEmp
	from empleado2
	where NumEmp = NumeroEmp;
if SalarioEmp < 1500 then
	update empleado2
    set Comision = salario*0.05
    where NumEmp = NumeroEmp;
elseif 1500 <= SalarioEmp < 2500 then
	update empleado2
    set Comision = salario*0.025
    where NumEmp = NumeroEmp;
else
	update empleado2
    set Comision = 0
    where NumEmp = NumeroEmp;
end if;
select comision into ComisionFinal
	from empleado2
	where NumEmp = NumeroEmp;

select concat ('Al empleado numero ', NumeroEmp, ' se le ha asignado una comision de ',ComisionFinal) mensaje;
end; //

call AsignarComision(11); //


/*11. Crea una función llamada SalarioJefe que reciba el nombre de un empleado y que devuelva un
número real que tome el valor del salario del empleado dividido entre el número de empleados
subordinados que tenga. En caso de que el empleado no tenga subordinados, la función deberá
devolver el valor -1.*/

delimiter //


/*12. Crea un procedimiento llamado IncrementarComisión que reciba el número de un empleado y
que en función del número de subordinados de ese empleado se le incremente la comisión del
siguiente modo: si el empleado no tiene subordinados, se le incrementará la comisión en 10 €; si
tiene un subordinado, se le incrementará la comisión en 25 €; si tiene 2 subordinados, se le
incrementará la comisión en 60 €; si tiene 3 subordinados, se le incrementará la comisión en 100
€; en cualquier otro caso, se le incrementará la comisión en 200 €. Puedes hacer uso de la función
creada en la actividad 8 para obtener el número de subordinados de un empleado. Muestra al final
un mensaje indicando el incremento de comisión de que ha disfrutado el empleado*/