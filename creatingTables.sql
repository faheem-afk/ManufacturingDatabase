create database project3 
use project3

-- Suppliers Table:
drop table suppliers
create table suppliers(
	supplierId int primary key identity(1,1),
	supplierCode varchar(50) not null unique,
	supplierName nvarchar(50) not null
)

-- Customers Table:
drop table customers
create table customers(
	customerId int primary key identity(1,1),
	customerCode varchar(50) not null unique,
	customerName nvarchar(50) not null
)

-- materials table:
drop table materials
create table materials(
	materialId int primary key identity(1,1),
	materialName nvarchar(50) not null
)

-- RawMaterial Table:
drop table rawMaterial
create table rawMaterial(
	rawMaterialId int primary key identity(1,1),
	materialName int not null,
	rawMaterialGrade nvarchar(50) null,
	constraint fk_materialName foreign key(MaterialName) references materials,
	constraint unique_material unique(MaterialName, rawMaterialGrade)
)


-- machines:
drop table machines
create table machines(
	machineId int primary key identity(1,1),
	machineName nvarchar(50) not null
	)

drop table machineType
create table machineType(
	machineTypeId int primary key identity(1,1),
	machineType nvarchar(50)
	)

drop table plants
create table plants(
	plantId int primary key identity(1,1),
	plantName varchar(10)
	)

-- Machines Table:
drop table machionary
create table machionary(
	machionaryId int primary key identity(1,1),
	machineName int,
	machineType int,
	plantId int not null,
	lastMaintenanceDate date,
	constraint fk_machineName foreign key(machineName) references machines,
	constraint fk_machineType foreign key(machineType) references machineType,
	constraint fk_plantId foreign key(plantId) references plants
)

-- Production Table:
drop table production
create table production(
	productionId int primary key identity(1,1),
	orderDate datetime not null,
	customerId int not null,
	componentToproduce nvarchar(50) not null,
	quantityToproduce int not null,
	machionaryId int not null,
	scheduledStartDate datetime not null,
	scheduledEndDate datetime not null,
	[status] nvarchar(50) not null,
	constraint fk_customerId foreign key(customerId) references customers,
	constraint chk_status check([status] in ('Scheduled', 'In Progress', 'Complete', 'On Hold', 'Cancelled', 'Rework Required', 'Quoted', 'Pending Materials', 'Rework Completed')),
	constraint chk_order_date check(scheduledStartDate >= orderDate),
	constraint chk_scheduleSequence check(scheduledEndDate >= scheduledStartDate),
	constraint fk_machionaryId foreign key(machionaryId) references machionary
	)


-- Material Inventory:
drop table materialInventory
create table materialInventory(
	batchId int primary key identity(1,1),
	originalBatchId nvarchar(50) unique,
	materialId int not null,
	supplierId int not null,
	receivedDate datetime not null,
	initialQuantity decimal(10,2) not null,
	remainingQuantity decimal(10,2) not null,
	unit nvarchar(10) not null,
	constraint fk_materialId foreign key(materialId) references Materials,
	constraint fk_supplierId foreign key(supplierId) references suppliers

)

-- Material Usage:
drop table materialusage
create table materialUsage(
	usageId int primary key identity(1,1),
	batchId int not null,
	productionId int not null,
	quantityUsed decimal(10,2) not null
	constraint fk_batchId foreign key(batchId) references materialInventory,
	constraint fk_productionId foreign key(productionId) references production

)

-- Employees:
drop table employees
create table employees(
	employeeId int primary key identity(1,1),
	employeeName nvarchar(50) not null
)


-- Quality check:
drop table qualityCheck
create table qualityCheck(
	qualityCheckId int primary key identity(1,1),
	originalQualityCheckId nvarchar(50),
	productionId int not null,
	inspectorId int not null,
	checkTimeStamp datetime not null,
	results nvarchar(10),
	constraint fk_inspectorId foreign key(inspectorId) references employees,
	constraint fk_productionId_qualityCheck foreign key(productionId) references production
)


-- Migration of data from the original source to my database
select * from abc_10000

-- suppliers:
	-- analysis:

	select distinct supplierID from abc_10000 order by supplierID
	select distinct supplierName from abc_10000 
	select distinct supplierID, supplierName from abc_10000 order by supplierID

	-- this tells us there exist a many-to-many relationship between supplierID and supplierName, therefore we can just drop the supplierCode column as it's not unqiuely identifying 
	-- the suppliers.
	alter table suppliers
	drop constraint UQ__supplier__35C84800C19EDDC6 -- first we need to drop the constraint, only then we can drop the column that corresponds to this constraint

	alter table suppliers
	drop column supplierCode

	
	-- inserting unique supplier names into the suppliers table
	insert into suppliers(suppliername)
	select distinct
		case 
			when suppliername like '%plasticpro%' then 'plasticpro inc.'
			when suppliername like 'steel co%' then 'steelcorp'
			when suppliername like 'copper co%' then 'copperco'
			when suppliername like 'alu works%' then 'aluworks'
			when suppliername like 'globalMetals%' then 'global metals'
			else suppliername 
		end 
	from abc_10000 where supplierName is not null


	select * from suppliers


-- customers:
select * from abc_10000

	-- analysis:
	select distinct customerorderid from abc_10000
	select distinct customername from abc_10000

	-- it seems that the customerorderId given in the original table works in batches, as one customerorderId is associated with multiple customers.
	-- so we drop the customercode from the customers table in the same way we dropped the previous column from suppliers table.

	alter table customers
	drop constraint UQ__customer__47BC9F2DC15C9AC4
	
	alter table customers
	drop column customercode

	-- inserting data into the customers table
	insert into customers(customername)
	select distinct customername from abc_10000 order by customername

	select * from customers

-- materials:
insert into materials(materialname)
select distinct materialname from abc_10000
select * from materials

-- rawMaterial:
select * from abc_10000
	-- analysis:
	select distinct materialname, materialgrade from abc_10000 order by materialname, materialgrade
	-- keep the pairs unique

	insert into rawmaterial(materialname, rawmaterialgrade)
	select distinct m.materialId, materialgrade from materials m
	join abc_10000 a
		on m.materialname = a.materialname
	order by m.materialId

	
-- machines:
insert into machines(machineName)
select distinct machineName from abc_10000

-- machineType:
insert into machineType(machineType)
select distinct machineType from abc_10000

select * from machines
select * from machineType

select m.machineId, mt.machineTypeId, a.LastMaintenanceDate from machines m
join abc_10000 a
	on m.machineName = a.machineName
join machineType mt
	on a.machineType = mt.machineType
order by m.machineId, mt.machineTypeId, a.LastMaintenanceDate


insert into machines(machineName)
select distinct right(machineName, len(machineName)-3) from abc_10000

insert into plants(plantName)
select distinct left(machineName, 2) from abc_10000

select * from machines
select * from machineType
select * from plants

insert into machionary(machineName, machineType, plantId, lastMaintenanceDate)
select m.machineId, mt.machineTypeId, p.plantId, max(try_convert(date, lastMaintenanceDate)) from machineType mt
join abc_10000 a
	on mt.machineType = a.machineType
join machines m
	on m.machineName = right(a.machineName, len(a.machineName)-3)
join plants p
	on p.plantName = left(a.machineName,2)
group by m.machineId, mt.machineTypeId, p.plantId


-- Material Inventory

select distinct RawMaterialBatchId from abc_10000

-- checking whether the alphabets are impurity or not
select distinct left(RawMaterialBatchId,7) from abc_10000 --implies the alphabets could be or could be not an impurity as the number of items in the colunn are same before and 
-- after adding the alphabets. so we can just remove them.


select r.rawMaterialId, 
	   s.supplierId, 
	   a.RawMaterialBatchId, 
	   receiveDate, 
	   cast(replace(replace(InitialQuantity, ',', ''), '$', '') as float), 
	   unit, 
	   cast(replace(QuantityToProduce, ',', '') as float),
	   (cast(replace(replace(InitialQuantity, ',', ''), '$', '') as float) - cast(replace(QuantityToProduce, ',', '') as float)) as remainingQuantity  from rawmaterial r
join materials m 
	on r.materialName = m.materialId
join abc_10000 a
	on m.materialName = a.materialName and
	r.rawmaterialGrade = a.materialGrade
join suppliers s
	on left(s.supplierName, 4) = left(a.supplierName, 4)

select distinct receiveDate from abc_10000 