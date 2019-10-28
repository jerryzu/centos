drop table  if exists pay;
create temporary table pay
select  
        due.c_ply_no
        , due.c_app_no
        , due.c_cav_no
        , due.c_rcpt_no
        , mny.n_item_no
        , mny.c_cav_pk_id
        , mny.c_payer_nme         as acc_name -- 交费账号名称
        , mny.c_savecash_bank          as acc_no -- 交费账号
        , mny.c_bank_nme	          as acc_bank -- 交费账户开户机构名称
from ods_cthx_web_fin_prm_due partition(pt20191013000000) due
    	inner join ods_cthx_web_fin_cav_mny partition(pt20191013000000) mny on due.c_cav_no = mny.c_cav_pk_id
order by  due.c_app_no, due.c_rcpt_no desc,  mny.n_item_no desc;   	

drop table  if exists pay1;
create temporary table pay1
select 
        c_ply_no
        , c_app_no
        , acc_name -- 交费账号名称
        , acc_no -- 交费账号
        , acc_bank -- 交费账户开户机构名称
from (select  
                c_ply_no
                , c_app_no
                , acc_name -- 交费账号名称
                , acc_no -- 交费账号
                , acc_bank -- 交费账户开户机构名称
                ,if(@u=c_app_no ,@r:=@r+1,@r:=1) as rank
                ,@u:=c_app_no 
        from pay, (select @u:=null, @r:=0) r 
        order by  c_app_no, c_rcpt_no desc,  n_item_no desc   	
) v
where rank = 1;

create  table rpt_fxq_tb_ply_base
select 
	a.c_app_no-- 投保单号
	, a.c_brkr_cde-- 销售渠道名称
	, a.c_cha_subtype 
	, a.c_dpt_cde
	, a.c_edr_ctnt -- 变更内容摘要
	, a.c_edr_type
	, a.c_edr_no as endorse_no-- 批单号
	, a.c_edr_rsn_bundle_cde-- 业务类型 11:退保;12:减保;13:保单部分领取;14:保单贷款;15:其他
	, a.c_ply_no -- 保单号
	, a.c_prm_cur 
	, a.c_prod_no -- 险种代码 
	, a.n_prm -- 本期交保费金额
	, a.n_prm_var --测试此条件没有满足记录
	, a.t_app_tm  -- 投保日期
	, a.t_edr_app_tm -- 申请日期
	, a.t_edr_bgn_tm -- 变更或批改日期
	, a.t_insrnc_bgn_tm -- 合同生效日期
	, a.t_insrnc_end_tm
	, a.t_next_edr_bgn_tm
        , acc_name -- 交费账号名称
        , acc_no -- 交费账号
        , acc_bank -- 交费账户开户机构名称
from  ods_cthx_web_ply_base partition(pt20191013000000)  a
     left join pay1 p on a.c_app_no = p.c_app_no    
where a.t_next_edr_bgn_tm > now() 


ods_cthx_web_app_insured
,a.c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
,a.c_acth_certf_cls  -- 控股股东或者实际控制人身份证件类型
,a.c_actualholding_nme  -- 控股股东或者实际控制人姓名
,a.c_aml_country c_country -- 国籍
,a.c_app_relation
,a.c_buslicence_no  -- 依法设立或经营的执照号码
,a.c_buslicence_valid -- 依法设立或经营的执照有效期限到期日
,a.c_certf_cde  -- 证件号码
,a.c_certf_cls  -- 证件种类
,a.c_cevenue_no  -- 税务登记证号码
,a.c_clnt_addr -- 实际经营地址或注册地址
,a.c_clnt_mrk
,a.c_cntr_nme c_ope_name -- 授权办理业务人员名称
,a.c_insured_nme c_acc_name -- 被保人名称
,a.c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
,a.c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
,a.c_legal_nme  -- 法定代表人或负责人姓名
,a.c_manage_area  -- 经营范围/业务范围
,a.c_mobile  -- 移动电话
,a.c_occup_cde -- 职业代码  
,a.c_operater_certf_cde -- 授权办理业务人员身份证件号码
,a.c_organization_no  -- 组织机构代码
,a.c_sex c_cst_sex -- 性别
,a.c_trd_cde  -- 行业 --c_sub_trd_cde
,a.c_work_dpt -- 工作单位
,a.n_income  -- 年薪
,a.t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日
,a.t_certf_end_date -- 证件有效期止
,a.t_legal_certf_end_tm  -- 有效期限到期日
,a.t_operater_certf_end_tm  -- 授权办理业务人员身份证件有效期限到期日


ods_cthx_web_ply_applicant
,a.c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
,a.c_acth_certf_cls -- 控股股东或者实际控制人身份证件类型
,a.c_actualholding_nme  -- 控股股东或者实际控制人姓名
,a.c_aml_country c_country -- 国籍
,a.c_app_nme c_acc_name -- 投保人名称
,a.c_buslicence_no -- 依法设立或经营的执照号码
,a.c_buslicence_valid -- 依法设立或经营的执照有效期限到期日
,a.c_certf_cde  -- 证件号码
,a.c_certf_cls  -- 证件种类
,a.c_cevenue_no -- 税务登记证号码
,a.c_clnt_addr -- 实际经营地址或注册地址
,a.c_clnt_mrk
,a.c_cntr_nme c_ope_name -- 授权办理业务人员名称
,a.c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
,a.c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
,a.c_legal_nme -- 法定代表人或负责人姓名
,a.c_manage_area -- 经营范围/业务范围
,a.c_mobile  -- 移动电话
,a.c_occup_cde  -- 职业代码
,a.c_organization_no -- 组织机构代码
,a.c_sex c_cst_sex -- 性别
,a.c_sub_trd_cde  -- 行业
,a.c_trd_cde  -- 行业代码
,a.c_work_dpt  -- 工作单位
,a.t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日
,a.t_certf_end_date -- 证件有效期止
,a.t_legal_certf_end_tm -- 有效期限到期日


ods_cthx_web_ply_bnfc
,a.c_addr  -- 实际经营地址或注册地址
,a.c_bnfc_nme  -- 受益人名称
,a.c_certf_cde  -- 证件号码
,a.c_certf_cls -- 证件类型
,a.c_clnt_mrk
,a.c_cntr_nme  -- 授权办理业务人员名称
,a.c_country -- 国家
,a.c_mobile   -- 移动电话
,a.c_sex   -- 性别

ods_cthx_web_app_grp_member
a.c_cert_typ
a.c_cert_no  -- 被保人编码  
a.c_bnfc_cert_typ
a.c_bnfc_cert_no  --  受益人编码 

ods_cthx_web_ply_ent_tgt
c_tgt_addr 保险标的物
c_ply_no

ods_cthx_web_bas_edr_rsn c
?? ods_cthx_web_ply_base a
??a.c_edr_rsn_bundle_cde=c.c_rsn_cde and substr(a.c_prod_no,1,2)=c.c_kind_no
c_rsn_cde
c_rsn_cde
c_kind_no