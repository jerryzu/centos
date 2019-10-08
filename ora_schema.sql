set colsep ,  
set feedback off  
set heading off  
set trimout on  
spool /home/tpodps/lfc.csv  
select '"' || c.table_name || '","' || c.column_id || '","' || c.column_name || '","' || c.data_type || '","' || c.data_length || '","' || c.data_precision || '","' || c.data_scale || '","' || 
c.nullable || '","' || cc.comments || '"' from user_tab_cols c inner join user_col_comments cc on c.table_name = cc.table_name and c.column_name = cc.column_name where c.table_name = 'T_BANKTRA
NSACTIONS';
spool off  
exit 
