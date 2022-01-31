USE [grupo06]
GO

if OBJECT_ID('[Dim_Cliente]') is not null
	drop table [Dim_Cliente] 
go

create table	Dim_Cliente							
(	Cliente_ID			varchar	(10)		not null,
	Nombre_Cliente		varchar	(200)		not null,
	Pais				varchar	(20)		not null,
	Ubigeo				char	(6)			not null
)	
go

SELECT * FROM [dbo].[Dim_Cliente]
GO

--==========================================================================

if OBJECT_ID('[Dim_Ubigeo]') is not null								
	drop table [Dim_Ubigeo] 							
go								
create table	Dim_Ubigeo							
(	Pais			varchar	(20)		not null,
	Ubigeo			char	(6)			not null,
	Nombre			varchar	(50)		not null,
	Latitud			decimal	(12,4)		not null,
	Longitud		decimal	(12,4)		not null
)								
go								
SELECT * FROM [dbo].[Dim_Ubigeo]								
go								

--==========================================================================

if OBJECT_ID('[Dim_Empleado]') is not null								
	drop table [Dim_Empleado] 							
go								
create table	Dim_Empleado							
(	Empleado_ID				int					not null,
	Nombres_Empleado		varchar	(35)		not null,
	Apellidos_Empleado		char	(35)		not null
)								
go								
SELECT * FROM [dbo].[Dim_Empleado]								
go								

--==========================================================================

if OBJECT_ID('[Dim_Producto]') is not null								
	drop table [Dim_Producto] 							
go								
create table	Dim_Producto							
(	Producto_ID			int					not null,
	Nombre_Producto		varchar	(100)		not null,
	Categoria_ID		int					not null,
	Costo_Unitario		decimal	(12,2)		not null
)								
go								
SELECT * FROM [dbo].[Dim_Producto]								
go								

--==========================================================================

if OBJECT_ID('[Dim_Categoria]') is not null								
	drop table [Dim_Categoria] 							
go								
create table	Dim_Categoria							
(	Categoria_ID			int					not null,
	Nombre_Categoria		varchar	(30)		not null
)								
go								
SELECT * FROM [dbo].[Dim_Categoria]								
go								

--==========================================================================

if OBJECT_ID('[Fact_Ventas]') is not null								
	drop table [Fact_Ventas] 							
go								
create table	Fact_Ventas							
(	Cliente_ID			varchar	(	10	)			not null,
	Empleado_ID			int							not null,
	Nro_Pedido			int							not null,
	Fecha_Pedido		date						not null,
	Producto_ID			int							not null,
	Costo_Unitario		decimal	(	12,2	)		not null,
	Cantidad			decimal	(	12,2	)		not null,
	Total_Venta			as	(Costo_Unitario * Cantidad)
)								
go								
SELECT * FROM [dbo].[Fact_Ventas]								
go								


--==========================================================================

-- *** Claves primarias y Campos con valores únicos ***
alter table Dim_Cliente
add constraint pk_Dim_Cliente primary key (Cliente_ID)
go
alter table Dim_Cliente
add constraint uq_Dim_Cliente_nombre unique (Nombre_Cliente)
go

alter table Dim_Ubigeo
add constraint pk_Dim_Ubigeo primary key (Pais, Ubigeo)
go

alter table Dim_Empleado
add constraint pk_Dim_Empleado primary key (Empleado_ID)
go
alter table Dim_Empleado
add constraint uq_Dim_Empleado_nombre unique (Nombres_Empleado, Apellidos_Empleado)
go

alter table Dim_Producto
add constraint pk_Dim_Producto primary key (Producto_ID)
go
alter table Dim_Producto
add constraint uq_Dim_Producto_nombre unique (Nombre_Producto)
go

alter table Dim_Categoria
add constraint pk_Dim_Categoria primary key (Categoria_ID)
go
alter table Dim_Categoria
add constraint uq_Dim_Categoria_nombre unique (Nombre_Categoria)
go

alter table Fact_Ventas
add constraint pk_Fact_Ventas primary key (Cliente_ID, Empleado_ID, Nro_Pedido)
go


--==========================================================================

-- *** Chequeo de restricciones de datos y valores por defecto ***
alter table Dim_Cliente
add constraint ck_Dim_Cliente_Nombre_Cliente01 check (len(Nombre_Cliente)>=5)
go
alter table Dim_Cliente
add constraint ck_Dim_Cliente_Nombre_Cliente02 check (Nombre_Cliente like '%[aeiou]%')
go

alter table Dim_Ubigeo
add constraint df_Dim_Ubigeo_Pais default ('Perú') for Pais
go

alter table Dim_Empleado
add constraint ck_Dim_Empleado_Nombres_Empleado01 check (len(Nombres_Empleado)>=5)
go
alter table Dim_Empleado
add constraint ck_Dim_Empleado_Nombres_Empleado02 check (Nombres_Empleado like '%[aeiou]%')
go
alter table Dim_Empleado
add constraint ck_Dim_Empleado_Apellidos_Empleado01 check (len(Apellidos_Empleado)>=2)
go

alter table Dim_Producto
add constraint ck_Dim_Producto_Nombre_Producto01 check (len(Nombre_Producto)>=5)
go
alter table Dim_Producto
add constraint ck_Dim_Producto_Nombre_Producto02 check (Nombre_Producto like '%[aeiou]%')
go

alter table Dim_Categoria
add constraint ck_Dim_Categoria_Nombre_Categoria01 check (len(Nombre_Categoria)>=5)
go
alter table Dim_Categoria
add constraint ck_Dim_Categoria_Nombre_Categoria02 check (Nombre_Categoria like '%[aeiou]%')
go

alter table Fact_Ventas
add constraint ck_Fact_Ventas_Fecha_Pedido01 check (Fecha_Pedido<=GetDate())
go
alter table Fact_Ventas
add constraint ck_Fact_Ventas_Costo_Unitario01 check (Costo_Unitario>0)
go
alter table Fact_Ventas
add constraint ck_Fact_Ventas_Cantidad01 check (Cantidad>0)
go


--==========================================================================

-- *** Relaciones entre tablas ***
alter table Dim_Cliente add constraint fk_Dim_Cliente_y_Dim_Ubigeo
foreign key(Pais, Ubigeo) references Dim_Ubigeo(Pais, Ubigeo)
go

alter table Dim_Producto add constraint fk_Dim_Producto_y_Dim_Categoria
foreign key(Categoria_ID) references Dim_Categoria(Categoria_ID)
go

alter table Fact_Ventas add constraint fk_Fact_Ventas_y_Dim_Producto
foreign key(Producto_ID) references Dim_Producto(Producto_ID)
go
alter table Fact_Ventas add constraint fk_Fact_Ventas_y_Dim_Cliente
foreign key(Cliente_ID) references Dim_Cliente(Cliente_ID)
go
alter table Fact_Ventas add constraint fk_Fact_Ventas_y_Dim_Empleado
foreign key(Empleado_ID) references Dim_Empleado(Empleado_ID)
go




