drop table  if exists pay;
create temporary table pay
select  
        due.c_ply_no
        , due.c_app_no
        , due.c_cav_no
        , due.c_rcpt_no
        , mny.n_item_no
        , mny.c_cav_pk_id
        , mny.c_payer_nme         as acc_name -- �����˺�����
        , mny.c_savecash_bank          as acc_no -- �����˺�
        , mny.c_bank_nme	          as acc_bank -- �����˻�������������
from ods_cthx_web_fin_prm_due partition(pt20191013000000) due
    	inner join ods_cthx_web_fin_cav_mny partition(pt20191013000000) mny on due.c_cav_no = mny.c_cav_pk_id
order by  due.c_app_no, due.c_rcpt_no desc,  mny.n_item_no desc;   	

drop table  if exists pay1;
create temporary table pay1
select 
        c_ply_no
        , c_app_no
        , acc_name -- �����˺�����
        , acc_no -- �����˺�
        , acc_bank -- �����˻�������������
from (select  
                c_ply_no
                , c_app_no
                , acc_name -- �����˺�����
                , acc_no -- �����˺�
                , acc_bank -- �����˻�������������
                ,if(@u=c_app_no ,@r:=@r+1,@r:=1) as rank
                ,@u:=c_app_no 
        from pay, (select @u:=null, @r:=0) r 
        order by  c_app_no, c_rcpt_no desc,  n_item_no desc   	
) v
where rank = 1;

create  table rpt_fxq_tb_ply_base
select 
	a.c_app_no-- Ͷ������
	, a.c_brkr_cde-- ������������
	, a.c_cha_subtype 
	, a.c_dpt_cde
	, a.c_edr_ctnt -- �������ժҪ
	, a.c_edr_type
	, a.c_edr_no as endorse_no-- ������
	, a.c_edr_rsn_bundle_cde-- ҵ������ 11:�˱�;12:����;13:����������ȡ;14:��������;15:����
	, a.c_ply_no -- ������
	, a.c_prm_cur 
	, a.c_prod_no -- ���ִ��� 
	, a.n_prm -- ���ڽ����ѽ��
	, a.n_prm_var --���Դ�����û�������¼
	, a.t_app_tm  -- Ͷ������
	, a.t_edr_app_tm -- ��������
	, a.t_edr_bgn_tm -- �������������
	, a.t_insrnc_bgn_tm -- ��ͬ��Ч����
	, a.t_insrnc_end_tm
	, a.t_next_edr_bgn_tm
        , acc_name -- �����˺�����
        , acc_no -- �����˺�
        , acc_bank -- �����˻�������������
from  ods_cthx_web_ply_base partition(pt20191013000000)  a
     left join pay1 p on a.c_app_no = p.c_app_no    
where a.t_next_edr_bgn_tm > now() 


ods_cthx_web_app_insured
,a.c_acth_certf_cde  -- �عɹɶ�����ʵ�ʿ��������֤������
,a.c_acth_certf_cls  -- �عɹɶ�����ʵ�ʿ��������֤������
,a.c_actualholding_nme  -- �عɹɶ�����ʵ�ʿ���������
,a.c_aml_country c_country -- ����
,a.c_app_relation
,a.c_buslicence_no  -- ����������Ӫ��ִ�պ���
,a.c_buslicence_valid -- ����������Ӫ��ִ����Ч���޵�����
,a.c_certf_cde  -- ֤������
,a.c_certf_cls  -- ֤������
,a.c_cevenue_no  -- ˰��Ǽ�֤����
,a.c_clnt_addr -- ʵ�ʾ�Ӫ��ַ��ע���ַ
,a.c_clnt_mrk
,a.c_cntr_nme c_ope_name -- ��Ȩ����ҵ����Ա����
,a.c_insured_nme c_acc_name -- ����������
,a.c_legal_certf_cde  -- ���������˻��������֤������
,a.c_legal_certf_cls  -- ���������˻��������֤������
,a.c_legal_nme  -- ���������˻���������
,a.c_manage_area  -- ��Ӫ��Χ/ҵ��Χ
,a.c_mobile  -- �ƶ��绰
,a.c_occup_cde -- ְҵ����  
,a.c_operater_certf_cde -- ��Ȩ����ҵ����Ա���֤������
,a.c_organization_no  -- ��֯��������
,a.c_sex c_cst_sex -- �Ա�
,a.c_trd_cde  -- ��ҵ --c_sub_trd_cde
,a.c_work_dpt -- ������λ
,a.n_income  -- ��н
,a.t_acth_certf_end_tm -- �عɹɶ�����ʵ�ʿ��������֤����Ч���޵�����
,a.t_certf_end_date -- ֤����Ч��ֹ
,a.t_legal_certf_end_tm  -- ��Ч���޵�����
,a.t_operater_certf_end_tm  -- ��Ȩ����ҵ����Ա���֤����Ч���޵�����


ods_cthx_web_ply_applicant
,a.c_acth_certf_cde  -- �عɹɶ�����ʵ�ʿ��������֤������
,a.c_acth_certf_cls -- �عɹɶ�����ʵ�ʿ��������֤������
,a.c_actualholding_nme  -- �عɹɶ�����ʵ�ʿ���������
,a.c_aml_country c_country -- ����
,a.c_app_nme c_acc_name -- Ͷ��������
,a.c_buslicence_no -- ����������Ӫ��ִ�պ���
,a.c_buslicence_valid -- ����������Ӫ��ִ����Ч���޵�����
,a.c_certf_cde  -- ֤������
,a.c_certf_cls  -- ֤������
,a.c_cevenue_no -- ˰��Ǽ�֤����
,a.c_clnt_addr -- ʵ�ʾ�Ӫ��ַ��ע���ַ
,a.c_clnt_mrk
,a.c_cntr_nme c_ope_name -- ��Ȩ����ҵ����Ա����
,a.c_legal_certf_cde  -- ���������˻��������֤������
,a.c_legal_certf_cls  -- ���������˻��������֤������
,a.c_legal_nme -- ���������˻���������
,a.c_manage_area -- ��Ӫ��Χ/ҵ��Χ
,a.c_mobile  -- �ƶ��绰
,a.c_occup_cde  -- ְҵ����
,a.c_organization_no -- ��֯��������
,a.c_sex c_cst_sex -- �Ա�
,a.c_sub_trd_cde  -- ��ҵ
,a.c_trd_cde  -- ��ҵ����
,a.c_work_dpt  -- ������λ
,a.t_acth_certf_end_tm -- �عɹɶ�����ʵ�ʿ��������֤����Ч���޵�����
,a.t_certf_end_date -- ֤����Ч��ֹ
,a.t_legal_certf_end_tm -- ��Ч���޵�����


ods_cthx_web_ply_bnfc
,a.c_addr  -- ʵ�ʾ�Ӫ��ַ��ע���ַ
,a.c_bnfc_nme  -- ����������
,a.c_certf_cde  -- ֤������
,a.c_certf_cls -- ֤������
,a.c_clnt_mrk
,a.c_cntr_nme  -- ��Ȩ����ҵ����Ա����
,a.c_country -- ����
,a.c_mobile   -- �ƶ��绰
,a.c_sex   -- �Ա�

ods_cthx_web_app_grp_member
a.c_cert_typ
a.c_cert_no  -- �����˱���  
a.c_bnfc_cert_typ
a.c_bnfc_cert_no  --  �����˱��� 

ods_cthx_web_ply_ent_tgt
c_tgt_addr ���ձ����
c_ply_no

ods_cthx_web_bas_edr_rsn c
?? ods_cthx_web_ply_base a
??a.c_edr_rsn_bundle_cde=c.c_rsn_cde and substr(a.c_prod_no,1,2)=c.c_kind_no
c_rsn_cde
c_rsn_cde
c_kind_no