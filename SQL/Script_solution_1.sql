-- category name en la tabla de category no necesita distinct ya que es la tabla de categorias
select distinct(category_name)
from categories;

-- Listado de regiones distintas por clientes
select distinct(region)
from customers;

--Obtener una listade todos los títulos de contacto distintos:
select distinct(contact_title)
from customers;

--Obtener una lista de todos los clientes, ordenados por país:
select *
from customers
order by country;

--Pedidos ordenados por id de empleado y fecha del dispositivo:
select *
from orders o 
order by employee_id, order_date;

-- Insertar en customers un nuevo cliente
insert into customers (customer_id, company_name,contact_name)
values ('MAR', 'Martinez', 'Rodrigo Martinez')



-- Insertar una nueva region en la tabla region
insert into region (region_id, region_description)
values (5,'Center')

--Obtener todos los clientes de la tabla Customers donde el campo Región es NULL:
select *
from customers 
where region is null

--Obtener Product_Name y Unit_Price de la tabla Products, y si Unit_Price es NULL, use
--el precio estándar de $10 en su lugar:
select product_name , coalesce(unit_price,10) 
from products

--Obtener el nombre de la empresa, el nombre del contacto y la fecha del pedido de todos
--los pedidos:
select c.company_name, c.contact_name, o.order_date	
from orders o
inner join customers c 
on o.customer_id=c.customer_id

--Obtener la identificación del pedido, el nombre del producto y el descuento de todos los
--detalles del pedido y productos:
select od.order_id, p.product_name, od.discount
from order_details od 
inner join products p 
on od.product_id = p.product_id 


--Obtener el identificador del cliente, el nombre de la compañía, el identificador y la fecha
--de la orden de todas las órdenes y aquellos clientes que hagan match :
select c.customer_id , c.company_name , o.order_id , o.order_date 
from customers c
left join orders o 
on c.customer_id =o.customer_id 


--Obtener el identificador del empleados, apellido, identificador de territorio y descripción
--del territorio de todos los empleados y aquellos que hagan match en territorios:

select e.employee_id ,e.last_name , et.territory_id, t.territory_description 
from employees e  
left join employee_territories et
on e.employee_id =et.employee_id 
left join territories t 
on et.territory_id =t.territory_id 

--Obtener el identificador de la orden y el nombre de la empresa de todos las órdenes y
--aquellos clientes que hagan match:

select o.order_id , c.company_name 
from orders o 
left join customers c 
on o.customer_id  = c.customer_id 

--Obtener el identificador de la orden, y el nombre de la compañía de todas las órdenes y
--aquellos clientes que hagan match:
select o.order_id, c.company_name 
from orders o 
right join customers c 
on o.customer_id = c.customer_id  


--Obtener el nombre de la compañía, y la fecha de la orden de todas las órdenes y
--aquellos transportistas que hagan match. Solamente para aquellas ordenes del año 1996:
select s.company_name , o.order_date 
from shippers s 
right join orders o 
on shipper_id  =o.ship_via  
where o.order_date between '1996-01-01' and '1996-12-31'


--Obtener nombre y apellido del empleados y el identificador de territorio, de todos los
--empleados y aquellos que hagan match o no de employee_territories:
select e.first_name , e.last_name, et.territory_id 
from employees e 
full outer join employee_territories et 
on et.employee_id =e.employee_id 

--Obtener el identificador de la orden, precio unitario, cantidad y total de todas las
--órdenes y aquellas órdenes detalles que hagan match o no:
select od.order_id , od.unit_price , od.quantity , (od.quantity*od.unit_price) as total
from order_details od 
full outer join orders o 
on o.order_id =od.order_id 


--Obtener la lista de todos los nombres de los clientes y los nombres de los proveedores:
(select s.company_name  as nombre 
from suppliers s)
union
(select c.company_name  as nombre
from customers c)

--obtener la lista de los nombres de todos los empleados y los nombres de los gerentes de departamento
select e.first_name 
from employees e 

--Obtener los productos del stock que han sido vendidos:
select p.product_name, p.product_id 
from products p 
where p.product_id in (
	select od.product_id 
	from order_details od)


	
-- obtener los clientes que han realizado un pedido a Argentina
select c.company_name 
from customers c 
where c.customer_id in (
select o.customer_id
from orders o
where o.ship_country='Argentina')

--Obtener el nombre de los productos que nunca han sido pedidos por clientes de Francia:

select p.product_name 
from products p 
where p.product_id not in (
select od.product_id 
from orders o
left join order_details od 
on o.order_id =od.order_id 
where ship_country = 'France')


--Obtener la cantidad de productos vendidos por identificador de orden:
select od.order_id , sum(od.quantity)
from order_details od 
group by od.order_id 


-- obtener el promedio de productos en stock por producto
select p.product_name , avg(p.units_in_stock)
from products p 
group by p.product_name 


--Cantidad de productos en stock por producto, donde haya más de 100 productos en stock
select p.product_name , sum(p.units_in_stock) 
from products p 
group by p.product_name 
having sum(p.units_in_stock)>100

--Obtener el promedio de frecuencia de pedidos por cada compañía y solo mostrar
--aquellas con un promedio de frecuencia de pedidos superior a 10:

select c.company_name, avg(o.order_id)
from orders o   
left join customers c 
on o.customer_id =c.customer_id 
group by c.company_name
having avg(o.order_id)>10


--Obtener el nombre del producto y su categoría, pero muestre "Discontinued" en lugar
--del nombre de la categoría si el producto ha sido descontinuado:

select p.product_name ,
	   case (p.discontinued)
	   	when 1 then 'discontinued'
	   	when 0 then c.category_name 
	   	end discontinued 
from products p 
left join categories c 
on p.category_id  =c.category_id 


--Obtener el nombre del empleado y su título, pero muestre "Gerente de Ventas" en lugar
--del título si el empleado es un gerente de ventas (Sales Manager):
select e.first_name, 
       e.last_name, 
	   case(e.title)
	   when 'Sales Manager' then 'Gerente de Ventas'
	   else e.title 
	   end job_title
from employees e 


