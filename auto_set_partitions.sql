开启事件调度器（默认关闭）

SET GLOBAL event_scheduler = ON; 
分区脚本

use test;


DELIMITER ||
-- 删除存储过程
drop procedure if exists auto_set_partitions ||
-- 注意：使用该存储过程必须保证相应数据库表中至少有一个手动分区
-- 创建存储过程[通过数据库名和对应表名]-建多少个分区，分区时间间隔为多少
-- databasename：创建分区的数据库
-- tablename：创建分区的表的名称
-- partition_number：一次创建多少个分区
-- partitiontype：分区类型[0按天分区，1按月分区，2按年分区]
-- gaps：分区间隔，如果分区类型为0则表示每个分区的间隔为 gaps天；
--       如果分区类型为1则表示每个分区的间隔为 gaps月
--            如果分区类型为2则表示每个分区的间隔为 gaps年
create procedure auto_set_partitions (in databasename varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,in tablename varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, in partition_number int, in partitiontype int, in gaps int)
L_END:
begin     
    declare max_partition_description varchar(255) default '';
    declare p_name varchar(255) default 0;       
    declare p_description varchar(255) default 0;   
    declare isexist_partition varchar(255) default 0; 
    declare i int default 1;
  
 -- 查看对应数据库对应表是否已经有手动分区[自动分区前提是必须有手动分区]
    select partition_name into isexist_partition from information_schema.partitions where table_schema = databasename  and table_name = tablename limit 1;
    -- 如果不存在则打印错误并退出存储过程
    if isexist_partition <=> "" then
       select "partition table not is exist" as "ERROR";
       leave L_END;
    end if;
 
    -- 获取最大[降序获取]的分区描述[值]
    select partition_description into max_partition_description  from information_schema.partitions where table_schema = databasename  and table_name = tablename order by partition_description desc limit 1;
   
    -- 如果最大分区没有,说明没有手动分区,则无法创建自动分区
    if max_partition_description <=> "" then
       select "partition table is error" as "ERROR";
       leave L_END;
    end if;
 
    -- 替换前后的单引号[''两个引号表示一个单引号的转义]
    -- set max_partition_description = REPLACE(max_partition_description, '''', '');
     -- 或使用如下语句
     set max_partition_description = REPLACE(max_partition_description-1, '\'', '');
 
   -- 自动创建number个分区
    while (i <= partition_number) do
                 if (partitiontype = 0) then
                     -- 每个分区按天递增,递增gaps天
                     set p_description = DATE_ADD(FROM_DAYS(max_partition_description), interval i*gaps day); 
                 elseif (partitiontype = 1) then
                     -- 每个分区按月递增,递增gaps月
                     set p_description = DATE_ADD(FROM_DAYS(max_partition_description), interval i*gaps month); 
                 else 
                     -- 每个分区按年递增,递增gaps年
                     set p_description = DATE_ADD(FROM_DAYS(max_partition_description), interval i*gaps year);
                 end if;
                 -- 删除空格
                 set p_name = REPLACE(p_description, ' ', '');
                 -- 例如10.20的记录实际是less than 10.21
                 set p_description = DATE_ADD(p_description, interval 1 day); 
                 -- 如果有横杆替换为空
          set p_name = REPLACE(p_name, '-', '');
                 -- 删除时间冒号
                 set p_name = REPLACE(p_name, ':', '');
                 -- alter table tablename add partition ( partition pname values less than ('2017-02-20 10:05:56') );
          set @sql=CONCAT('ALTER TABLE ', tablename ,' ADD PARTITION ( PARTITION p', p_name ,' VALUES LESS THAN (TO_DAYS(\'', p_description ,'\')))');
                 -- set @sql=CONCAT('ALTER TABLE ', tablename ,' ADD PARTITION ( PARTITION p', p_name ,' VALUES LESS THAN (TO_DAYS(\'', p_description ,'\')))');
                 -- 打印sql变量
          -- select @sql;
                 -- 准备sql语句
          PREPARE stmt from @sql;
                 -- 执行sql语句
          EXECUTE stmt;
                 -- 释放资源
          DEALLOCATE PREPARE stmt;
                 -- 递增变量
          set i = (i + 1) ;
 
    end while;          
end ||
-- 恢复语句中断符
DELIMITER ;


添加事件处理，每天执行一次

DELIMITER ||
drop event if exists auto_set_partitions  ||
create event auto_set_partitions 
on schedule every 1 day
starts '2018-10-30 23:59:59'
do
BEGIN
    call auto_set_partitions('test', 'position', 1, 0, 1);
END ||
DELIMITER ;


删除表中分区
alter table table_name drop partition p0;
修改事件
ALTER EVENT
event_name

ON SCHEDULE schedule
[RENAME TO new_event_name][ON COMPLETION [NOT] PRESERVE]
[ENABLE | DISABLE][COMMENT 'comment']
DO sql_statement
删除事件
DROP EVENT [IF EXISTS] auto_set_partitions;
但当一个事件正在运行中时，删除该事件不会导致事件停止，事件会执行到完毕为止

查看事件是否开启
show variables like 'event_scheduler';