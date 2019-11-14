set colsep ,  
set feedback off  
set heading off  
set trimout on  
spool /home/tpodps/ins_risk.csv  

select '"' || ts.app_or_ins || '","' || d3.c_dict_nme || '","' || ts.user_id || '","' || c.c_clnt_nme || '","' || d1.c_dict_nme || '","' || c.C_CERTF_CDE || '","' || to_char(ts.score_time, 'yyyy-mm-dd')  || '","' || d2.c_dict_nme || '","' || ts.previous_score || '","' || ts.bat || '","' || c.c_app_no prono ||  '"' 
from (select * from (select t.*, row_number() over(partition by t.user_id, t.app_or_ins order by t.bat desc) as rn from T_sco t) where rn = 1) ts
         join (select * from (select tt.*, row_number() over(partition by tt.c_clnt_cde, tt.app_or_ins order by tt.t_crt_tm desc) as rn from t_score tt) where rn = 1) c
        on c.c_clnt_cde = ts.user_id and c.app_or_ins = ts.app_or_ins
         join t_dict d1 on c.c_certf_type = d1.c_dict_cde and d1.c_dict_type_cde = 'PAPERS_TYPE'
         join t_dict d2 on ts.status = d2.c_dict_cde and d2.c_dict_type_cde = 'SCORE_STATUS'
         join t_dict d3 on ts.app_or_ins = d3.c_dict_cde and d3.c_dict_type_cde = 'APP_OR_INS';
spool off  
exit