create database project3 
use project3

----------------------------------- Suppliers Table:
drop table suppliers
create table suppliers(
	supplierId int primary key identity(1,1),
	supplierCode varchar(50) not null unique,
	supplierName nvarchar(50) not null
)
----------------------------------- Insertion into Supplier

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




----------------------------------- Customers Table:
drop table customers
create table customers(
	customerId int primary key identity(1,1),
	customerCode varchar(50) not null unique,
	customerName nvarchar(50) not null
)
----------------------------------- Insertion into Customers

alter table customers
drop constraint UQ__customer__47BC9F2D412427CC
	
alter table customers
drop column customercode

-- inserting data into the customers table
insert into customers(customername)
select distinct customername from abc_10000 order by customername

select * from customers




----------------------------------- materials table:
drop table materials
create table materials(
	materialId int primary key identity(1,1),
	materialName nvarchar(50) not null
)
----------------------------------- Insertion into materials:
insert into materials(materialname)
select distinct materialname from abc_10000
select * from materials




----------------------------------- RawMaterial Table:
drop table rawMaterial
create table rawMaterial(
	rawMaterialId int primary key identity(1,1),
	materialName int not null,
	rawMaterialGrade nvarchar(50) null,
	constraint fk_materialName foreign key(MaterialName) references materials,
	constraint unique_material unique(MaterialName, rawMaterialGrade)
)
----------------------------------- Insertion into rawMaterial:
select * from abc_10000
	-- analysis:
	select distinct materialname, materialgrade from abc_10000 order by materialname, materialgrade
	-- keep the pairs unique

	insert into rawmaterial(materialname, rawmaterialgrade)
	select distinct m.materialId, materialgrade from materials m
	join abc_10000 a
		on m.materialname = a.materialname
	order by m.materialId




----------------------------------- machines:
drop table machines
create table machines(
	machineId int primary key identity(1,1),
	machineName nvarchar(50) not null
	)
----------------------------------- Insertion into machines:
insert into machines(machineName)
select distinct right(machineName, len(machineName)-3)  from abc_10000





----------------------------------- MachineType)
drop table machineType
create table machineType(
	machineTypeId int primary key identity(1,1),
	machineType nvarchar(50)
	)
----------------------------------- Insertion into machineType:
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





----------------------------------- Plants Table
drop table plants
create table plants(
	plantId int primary key identity(1,1),
	plantName varchar(10)
	)
----------------------------------- Insertion into plants
insert into plants(plantName)
select distinct left(machineName, 2) from abc_10000





----------------------------------- Machionary Table:
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
----------------------------------- Insertion into machionary

insert into machionary(machineName, machineType, plantId, lastMaintenanceDate)
select distinct m.machineId, mt.machineTypeId, p.plantId, max(try_convert(date, lastMaintenanceDate)) from machineType mt
join abc_10000 a
	on mt.machineType = a.machineType
join machines m
	on m.machineName = right(a.machineName, len(a.machineName)-3)
join plants p
	on p.plantName = left(a.machineName,2)
group by m.machineId, mt.machineTypeId, p.plantId


select * from machionary

----------------------------------- Batches:
drop table [batches]
create table [batches](
	batch_id int primary key identity(1,1),
	batch_name varchar(20) 
)


----------------------------------- Inserting into batch
insert into [batches](batch_name)
select distinct left(RawMaterialBatchID, 7) from ABC_10000 


----------------------------------- Production Table:
drop table production
create table production(
	productionId int primary key identity(1,1),
	orderDate datetime not null,
	customerId int not null,
	componentToproduce nvarchar(50) not null,
	quantityToproduce float not null,
	machionaryId int not null,
	scheduledStartDate datetime not null,
	scheduledEndDate datetime not null,
	[status] nvarchar(50) not null,
	plantId int not null,
	constraint fk_customerId foreign key(customerId) references customers,
	constraint chk_status check([status] in ('Scheduled', 'In Progress', 'Completed', 'On Hold', 'Cancelled', 'Rework Required', 'Quoted', 'Pending Materials', 'Rework Complete')),
	constraint chk_order_date check(scheduledStartDate >= orderDate),
	constraint chk_scheduleSequence check(scheduledEndDate > scheduledStartDate),
	constraint fk_prod_plant foreign key(plantId) references plants,
	constraint fk_machionaryId foreign key(machionaryId) references machionary
	)
----------------------------------- Insertion into Productions table

insert into production(OrderDate, customerId, ComponentToProduce, QuantityToProduce, machionaryId, ScheduledStartDate, ScheduledEndDate, [Status], plantId)
select distinct 
	coalesce(try_convert(datetime, a.OrderDate, 105), 
			try_convert(datetime, a.OrderDate, 110), NULL) as OrderDate,
			c.customerId, a.ComponentToProduce, a.QuantityToProduce, mm.machionaryId, 
			try_convert(datetime, a.ScheduledStart, 105) as ScheduledStartDate, 
			try_convert(datetime, a.ScheduledEnd, 105) as ScheduledEndDate,  a.Status, p.plantId
from ABC_10000 a
join customers c
	on c.customerName = a.customerName 
join machines m
	on m.machineName = substring(a.MachineName, charindex('-', a.machineName)+1, len(a.MachineName))
join machineType mt 
	on mt.machineType = a.MachineType
join plants p
	on p.plantName = left(a.MachineName, 2)
join machionary mm 
	on (mm.machineName = m.machineId) and
	    (mm.machineType = mt.machineTypeId) and
		(mm.plantId = p.plantId)
where (try_convert(datetime, a.ScheduledStart, 105) < try_convert(datetime, a.ScheduledEnd, 105)) and 
		(try_convert(datetime, a.ScheduledStart, 105) 
			>= 
		(coalesce(try_convert(datetime, a.OrderDate, 105), try_convert(datetime, a.OrderDate, 110), NULL)))



----------------------------------- Material Inventory:
drop table materialInventory
create table materialInventory(
	materialInventoryId int primary key identity(1,1),
	originalBatchId nvarchar(50),
	rawmaterialId int not null,
	supplierId int not null,
	receivedDate date not null,
	initialQuantity decimal(10,2) not null,
	remainingQuantity decimal(10, 2) null,
	unit nvarchar(10) not null,
	constraint fk_rawMaterialId foreign key(rawMaterialId) references rawMaterial,
	constraint fk_supplierId foreign key(supplierId) references suppliers,
	constraint chk_unit check(unit in ('KG', 'M', 'PCS', 'FT', 'SQ_FT', 'LBS'))

)
----------------------------------- Insertion into Material Inventory
select * from materialInventory
insert into materialInventory(originalBatchId, rawMaterialId, supplierId, receivedDate, initialQuantity, unit)
select left(a.RawMaterialBatchID, 7) as originalBatchId,
	   r.rawMaterialId,
	   s.supplierId, 
	   try_convert(date, receiveDate, 105) as receivedDate, 
	   cast(replace(replace(InitialQuantity, ',', ''), '$', '') as float) as initialQuantity,
	   case 
		when upper(trim(unit)) in ('KG', 'KILOGRAM', 'KGS') THEN 'KG'
		when upper(trim(unit)) in ('M', 'METERS', 'METER') THEN 'M'
		when upper(trim(unit)) in ('FT', 'FEET') THEN 'FT'
		when upper(trim(unit)) in ('PCS', 'PIECES') THEN 'PCS'
		when upper(trim(unit)) in ('LBS') THEN 'LBS'
		when upper(trim(unit)) in ('SQ FT', 'SQUARE FEET') THEN 'SQ_FT'
		ELSE NULL
	END AS unit  
   from rawmaterial r

join materials m 
	on r.materialName = m.materialId
join abc_10000 a
	on m.materialName = a.materialName and
	r.rawmaterialGrade = a.materialGrade
join suppliers s
	on left(s.supplierName, 4) = left(a.supplierName, 4)


UPDATE mi
SET mi.remainingQuantity =
    CASE 
        WHEN mi.initialQuantity - COALESCE(mu.quantityUsed, 0) < 0 THEN 0
        ELSE mi.initialQuantity - COALESCE(mu.quantityUsed, 0)
    END
FROM materialInventory mi
left join [batches] b
	on mi.originalBatchId = b.batch_name
left join materialUsage mu
	on (b.batch_id = mu.batchid) and 
	(mi.rawMaterialId = mu.rawMaterialId)




----------------------------------- Material Usage:
drop table materialusage
create table materialUsage(
	usageId int primary key identity(1,1),
	batchId int not null,
	rawMaterialId int not null,
	productionId int not null,
	quantityUsed decimal(10,2) null
	constraint fk_rawUsageMaterialId foreign key(rawMaterialId) references rawMaterial,
	constraint fk_productionId foreign key(productionId) references production,
	constraint fk_batch_id foreign key(batchId) references [batches]

)
---------------------------- Insertion into materialUsage
insert into materialUsage(batchId, productionId, rawmaterialId, quantityUsed)
select b.batch_Id, p.productionId, m.materialId, a.QuantityUsed
from ABC_10000 a
inner join materials m
	on a.materialName = m.materialName
inner join rawmaterial r	
	on m.materialId= r.materialName
	and a.materialGrade = r.rawMaterialGrade
inner join [batches] b
	on b.batch_name = a.MaterialUsedBatchID
inner join production p
	on (p.quantityToproduce = a.QuantityToProduce) and
	(cast(p.scheduledStartDate as varchar(50)) = cast(try_convert(datetime, a.ScheduledStart, 105) as varchar(50)))
where QuantityUsed is not Null


select * from materialUsage
-- DBCC CHECKIDENT ('materialUsage', RESEED, 1);





----------------------------------- Employees:
drop table employees
create table employees(
	employeeId int primary key identity(1,1),
	employeeName nvarchar(50) not null,
	[role] nvarchar(50) not null
)


insert into employees (employeeName, [role])
select FullName, [role] from employee


select * from employees




----------------------------------- Quality check:
drop table qualityCheck
create table qualityCheck(
	qualityCheckId int primary key identity(1,1),
	originalQualityCheckId nvarchar(50),
	productionId int not null,
	inspectorId int not null,
	checkTimeStamp datetime null,
	results nvarchar(10),
	constraint fk_inspectorId foreign key(inspectorId) references employees,
	constraint fk_productionId_qualityCheck foreign key(productionId) references production
)

insert into qualityCheck(originalQualityCheckId, productionId, inspectorId, checkTimeStamp, results)
select a.QualityCheckId, p.productionId, e.employeeId, coalesce(try_convert(datetime, a.CheckTimestamp, 105), try_convert(datetime, a.checkTimeStamp, 110)),
		a.Result from ABC_10000 a
join production p
	on (p.quantityToproduce = a.QuantityToProduce) and
	(cast(p.scheduledStartDate as varchar(50)) = cast(try_convert(datetime, a.ScheduledStart, 105) as varchar(50)))
join employees e
	on e.employeeName = a.InspectorName
where QualityCheckId is not null





--------------------------------------------- END 









 


