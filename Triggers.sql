use project3;





-------------------------------------- Implementing rules for consistency

---1 : FAILED QUALITY CHECK, STATUS SHOULD BE REWORK REQUIRED.

-- create a 'after-insert' trigger on qualityChecks ---> if status = failed ----> run a stored Procedure ----> perform the above steps 

drop trigger trg_qualityChecks;
create trigger trg_qualityChecks
on QualityCheck 
after insert, update
as
begin       
     
        update production
        set [status] = 'Rework Required'
        from production where productionId in
        (select productionId from inserted where results = 'FAILED')
        and [status] <> 'Rework Required'
  

end

update QualityCheck
set results = 'FAILED'
where originalQualityCheckId = 'QC-209' and productionId = 1910 and inspectorId = 2 and checkTimeStamp = '2025-04-21 16:21:00.000' and results=  'Passed'



----- 2: when a machine for production at a specific date, check whether the machine is available.
drop trigger trg_preventOverlappingSchedules
CREATE TRIGGER trg_preventOverlappingSchedules
ON production
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN production p
            ON i.productionId <> p.productionId
                AND (
                        (i.machionaryId = p.machionaryId)
                     OR (i.plantId = p.plantId)
                    )
            
                AND i.scheduledStartDate < p.scheduledEndDate
                AND i.scheduledEndDate > p.scheduledStartDate
    )
    BEGIN
        THROW 50000, 'Machine is already scheduled during the selected time range.', 1;
    END
END;


select * from production

select * from machionary


insert into production(orderDate, customerId, componentToproduce, quantityToproduce, machionaryId, scheduledStartDate, scheduledEndDate, [status], plantId)

values('2023-01-08 17:35:00.000', 5, 'Component I6',  230.450081, 49, '2025-02-28 11:37:00.000', '2025-04-26 05:34:00.000', 'Scheduled', 1 )


select * from QualityCheck



select machionaryId, scheduledStartDate, count(*) as c from production
group by machionaryId, scheduledStartDate
having count(*) > 1
order by c desc



-------------------------------------- if material usage is more than the remainingQuantity and the remainingQuantity hits < 0 

drop trigger trg_materialUsage
create trigger trg_materialUsage
on materialUsage
after insert, update
as
begin
        update materialInventory
        set remainingQuantity = mi.initialQuantity - i.quantityUsed
        from inserted i
          join batches b
                on b.batch_Id = i.batchId
          join materialInventory mi 
            on mi.originalBatchId = b.batch_name
            and mi.rawmaterialId = i.rawMaterialId
         
        
        if exists(
        select 1
         from inserted i
          join batches b
                on b.batch_Id = i.batchId
          join materialInventory mi 
            on mi.originalBatchId = b.batch_name
            and mi.rawmaterialId = i.rawMaterialId
     
         where mi.remainingQuantity < 0 )

         begin
            THROW 50000, 'Not Enough Material Available.', 1
            rollback transaction
         end
            
end


-------------------------------- set an alarm on materials whose quantity becomes less than 500
create table MaterialLowStockLog (
        LogId int primary key identity(1,1),
        rawMaterialId int not null,
        alertTriggerQuantity decimal(10, 2), 
        quantityToOrder decimal(10,2),
        alertDate datetime default getdate(),
        constraint fk_lowStrockRawmaterialId foreign key(rawMaterialId) references rawMaterial
)

drop trigger trg_lowStock
create trigger trg_lowStock
on materialInventory
after insert, update
as
begin   
            if exists(
                select 1 from inserted where remainingQuantity < 500
            )
            begin
                insert into MaterialLowStockLog
                select r.rawMaterialId, i.remainingQuantity, (500 - remainingQuantity) as QuantityToOrder, getdate() as alertDate 
                from inserted i 
                join rawMaterial r
                    on i.rawMaterialid = r.rawMaterialId
            end
end

select * from MaterialLowStockLog
select * from materialInventory


select * from materialusage



 update materialUsage
        set quantityUsed = 4444
        from materialusage
        where usageId = 88;

        select *
        from materialusage i
          join batches b
                on b.batch_Id = i.batchId
          join materialInventory mi 
            on mi.originalBatchId = b.batch_name
            and mi.rawMaterialId = i.rawmaterialId
        order by usageId
select * from MaterialLowStockLog


select * from ABC_10000