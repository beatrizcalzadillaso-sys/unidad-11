use pedidos_dam;

/* 1. Crea un procedimiento que añada un nuevo pedido a la tabla Pedido con datos pasados como
parámetro. Por tanto, este procedimiento recibirá como parámetros la referencia del pedido y la
fecha. Muestra al final un mensaje con el texto ‘Se ha añadido un pedido con referencia XXXXX’,
siendo XXXXX la referencia del nuevo pedido.*/

Delimiter //
create procedure addPedido (referencia char(5), fecha date)
begin
insert into pedido
values (referencia, fecha);
select concat('Se ha añadido un pedido con referencia', referencia) mensaje;
end;//

call addPedido('P0080', current_date());

/*2. Escribe un procedimiento que muestre en pantalla la descripción y el precio del artículo más
barato de la base de datos.*/
select PVPArt
from articulo
order by PVPArt
asc
limit 1;

select DesArt 
from articulo
where PVPArt = (select PVPArt
					from articulo
					order by PVPArt
					asc
					limit 1);
 
 Delimiter //
 create procedure showCheap()
 begin
 declare cheap decimal(6,2);
 declare desCheap varchar(30);
 select PVPArt into cheap
	from articulo
	order by PVPArt
	asc
	limit 1;
select DesArt into desCheap
	from articulo
	where PVPArt = (select PVPArt
						from articulo
						order by PVPArt
						asc
						limit 1);
select concat('El articulo mas barato es ', desCheap, ' y cuesta ', cheap) mensaje;
end;//

call showCheap();

/*3. Crea una función que nos devuelva la descripción del artículo más caro de la base de datos.*/

Delimiter //
 create function showExpensive() returns varchar(30) reads sql data
 begin
 declare expensive decimal(6,2);
 declare desExp varchar(30);
 select PVPArt into expensive
	from articulo
	order by PVPArt
	desc
	limit 1;
select DesArt into desExp
	from articulo
	where PVPArt = (select PVPArt
						from articulo
						order by PVPArt
						desc
						limit 1);
return desExp;
end;//

select showExpensive() 'Articulo mas caro';

/*4. Crea un procedimiento que reciba la referencia de un pedido y muestre en pantalla dicha referencia
y la fecha del pedido y se encargue de eliminarlo de la base de datos. Debe mostrase un mensaje
con el texto ‘Pedido XXXXX eliminado’.*/
Delimiter //
create procedure removePedido (referencia char(5))
begin
declare fecha date;
select FecPed into fecha
	from pedido
    where RefPed like referencia;
select concat('Pedido ', referencia, ' con fecha ',fecha, ' encontrado') 'Datos pedido';

delete from pedido
where RefPed like referencia;
select concat('Pedido ',referencia,' eliminado') mensaje2;
end;//

call removePedido('P0078');

/*5. Crea un procedimiento que reciba el código de un artículo y un número entero positivo o negativo.
El procedimiento debe modificar el precio del artículo según el porcentaje pasado como parámetro
y mostrar el precio del artículo antes y después de la modificación. Por ejemplo, si el
procedimiento recibe como segundo parámetro un 5, deberá subir el precio del artículo un 5%,
mientras que si recibe un -2, deberá bajar el precio del artículo un 2%. */
Delimiter //
create procedure modifyPrice (cod char(5), delta int)
begin
declare previous decimal(6,2);
declare actual decimal(6,2);
select PVPArt into previous
	from articulo
    where CodArt like cod;
select concat('Se modificara ',cod, ' ,precio anterior: ', previous) mensaje;
update articulo
set PVPArt = PVPArt + (PVPArt)*(delta/100)
	where CodArt like cod;
select PVPArt into actual
	from articulo
    where CodArt like cod;
select concat('Se modifico ',cod, ' ,precio actual: ', actual) mensaje2;
end;//

call modifyPrice('A0089', -5);
