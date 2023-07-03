-- Obtener el promedio de precios por cada categoría de producto. La cláusula
-- OVER(PARTITION BY CategoryID) específica que se debe calcular el promedio de
-- precios por cada valor único de CategoryID en la tabla.

select c.category_name,
	   p.product_name,
	   p.unit_price,
	   avg(p.unit_price) over (partition by p.category_id)
from products p 
left join categories c 
on p.category_id =c.category_id 

--Obtener el promedio de venta de cada cliente
select avg(od.quantity*od.unit_price) over (partition by o.customer_id),*
from orders o 
inner join order_details od 
on o.order_id =od.order_id

--Obtener el promedio de cantidad de productos vendidos por categoría (product_name,
--quantity_per_unit, unit_price, quantity, avgquantity) y ordenarlo por nombre de la
--categoría y nombre del producto
select p.product_name, 
	   c.category_name,
	   p.quantity_per_unit, 
	   p.unit_price, 
	   od.quantity, 
	   avg(od.quantity) over (partition by c.category_id) as avgquantity
from order_details od  
inner join products p
on od.product_id  = p.product_id
inner join categories c 
on p.category_id = c.category_id 
order by c.category_name, p.product_name 


--MIN 
--Selecciona el ID del cliente, la fecha de la orden y la fecha más antigua de la
--orden para cada cliente de la tabla 'Orders'.

select c.customer_id,
	   o.order_date,
	   min(o.order_date) over (partition by c.customer_id)
from customers c 
inner join orders o 
on c.customer_id = o.customer_id 


-- MAX
-- Seleccione el id de producto, el nombre de producto, el precio unitario, el id de
-- categoría y el precio unitario máximo para cada categoría de la tabla Products.
select p.product_id, 
	   p.product_name, 
	   p.unit_price,
	   c.category_id,
	   MAX(p.unit_price) over (partition by c.category_id) as maxunitprice
from products p 
inner join categories c 
on c.category_id = p.category_id 

--Row_number
--Obtener el ranking de los productos más vendidos

select row_number() over (order by table_1.totalquantity desc),
	   table_1.product_name,
	   table_1.totalquantity
from (select p.product_name,
	   sum(od.quantity) as totalquantity
from order_details od 
inner join products p 
on od.product_id = p.product_id 
group by p.product_name) table_1

--Asignar numeros de fila para cada cliente, ordenados por customer_id
select row_number() over(order by c.customer_id),
	   *
from customers c 


--Obtener el ranking de los empleados más jóvenes () ranking, nombre y apellido del
--empleado, fecha de nacimiento)
select row_number() over (order by e.birth_date desc),
	   concat(e.first_name,' ' ,e.last_name ) as employeename,
	   e.birth_date 
from employees e  


-- SUM
-- Obtener la suma de venta de cada cliente
select sum(od.unit_price*od.quantity) over (partition by o.customer_id), o.*
from orders o 
join order_details od 
on od.order_id =o.order_id 

--10.Obtener la suma total de ventas por categoría de producto
select c.category_name,
	   p.product_name,
	   p.unit_price,
	   od.quantity,
	   sum(od.unit_price*od.quantity) over(partition by c.category_id)
from order_details od 
join products p 
on p.product_id = od.product_id 
join categories c 
on c.category_id = p.category_id 
order by c.category_id, p.product_name

-- Calcular la suma total de gastos de envío por país de destino, luego ordenarlo por país
-- y por orden de manera ascendente
select o.ship_country,
	   o.order_id,
	   o.shipped_date,
	   o.freight,
	   sum(o.freight) over (partition by o.ship_country)
from orders o 
join (select od.order_id, 
	   sum(od.unit_price) as unit_price, 
	   sum(od.quantity)
from order_details od 
group by od.order_id ) table_1
on o.order_id = table_1.order_id
where shipped_date is not null


--rank
--Ranking de ventas por cliente

select *,
	   rank() over(order by table_1.Total_sales desc)
from(select o.customer_id,
	   c.company_name,
	   sum(od.unit_price*od.quantity) as Total_sales
from orders o 
join order_details od 
on o.order_id = od.order_id 
join customers c 
on o.customer_id =c.customer_id 
group by o.customer_id, c.company_name 
) table_1


--13.Ranking de empleados por fecha de contratacion

select e.employee_id ,
	   e.first_name,
	   e.last_name ,
	   e.hire_date ,
	   rank() over (order by e.hire_date)
from employees e 


--14.Ranking de productos por precio unitario
select p.product_id ,
       p.product_name ,
       p.unit_price ,
       rank() over (order by p.unit_price desc)
from products p 


--LAG
--15.Mostrar por cada producto de una orden, la cantidad vendida y la cantidad
--vendida del producto previo.
select od.order_id , 
       od.product_id , 
       od.quantity,
       lag(od.quantity)over(order by order_id) 
from order_details od 

--16.Obtener un listado de ordenes mostrando el id de la orden, fecha de orden, id del cliente
--y última fecha de orden.
select o.order_id ,
       o.order_date ,
       o.customer_id ,
       lag(o.order_date)over(partition by o.customer_id order by o.order_id)
from orders o  


--17.Obtener un listado de productos que contengan: id de producto, nombre del producto,
--precio unitario, precio del producto anterior, diferencia entre el precio del producto y
--precio del producto anterior.
select p.product_id ,
	   p.product_name ,
	   p.unit_price ,
	   lag(p.unit_price) over(order by p.product_id),
	   p.unit_price -lag(p.unit_price) over(order by p.product_id)
from products p 


--LEAD
--18.Obtener un listado que muestra el precio de un producto junto con el precio del producto
--siguiente:

select p.product_id ,
	   p.product_name ,
	   p.unit_price ,
	   lead (p.unit_price) over(order by p.product_id)
from products p 

--19.Obtener un listado que muestra el total de ventas por categoría de producto junto con el
--total de ventas de la categoría siguiente

select *,
	   lead(table_1.totalsales) over (order by table_1.category_name)
from (select c.category_name,
       sum(od.unit_price*od.quantity) as totalsales
from order_details od 
join products p 
on p.product_id  = od.product_id 
join categories c 
on c.category_id = p.category_id 
group by c.category_name ) table_1


