#!/bin/bash
#author bollenv@qq.com 2018-02-05
#��ѯ���ݿⲢ����ѯ�������������HTTP����
#SQL��ѯ�������
columnNum=2
#ͨ������������������λ��
function getValue(){
  #���÷�������ĵ�һ��������$0 ��ʾ������
  colIndex=$1
  #���÷�������ĵڶ�������
  rowIndex=$2
  #��λ��ָ���У���������0Ϊ��һ��Ԫ��
  #��ѧ��������ʹ�� $((a+b))
  idx=$(($columnNum*$colIndex+$rowIndex-1))
  #�ж�����ֵ�Ƿ���ڽ������
  #${#arrays_name[@]}��ȡ���鳤��
  if [ $idx -le ${#user_attrs[@]} ]; then
    echo ${user_attrs[$idx]}
  fi
}
#���ݿ��ѯ��������Ϊÿ�д�����ÿ����Ԫ��Ϊһ�У�����ΪSQL��ѯ�����������
#����Ĭ�Ϸָ�����ǿո񣬵���ѯ����а����ո��ַ�ʱ���ᵼ��һ���ֶα��ָ�����磺create_time 2017-01-01 12:12:12 �������� 
#2017-01-01
#12:12:12
#��ˣ�IFS=$'\t'����tab���ָ��ֶε�ֵ
#mysql -u �û��� -p ���� -h ����host ���ݿ��� -e ִ�нű�����
IFS=$'\t'
user_attrs=(`mysql -udb_user -pdb_pwd -hdb_host dbname -e 'SELECT \`city_name\`,\`name\` FROM t_user"'`)
#ѭ��������ѯ�������
for (( i=$columnNum; i<=${#user_attrs[@]}; i=i+1))
do
   #��ѯ���nameΪ����name��ֵ��nameΪ�ڶ��У�rowIndex���� 2
   #���÷�����Ҫ��``����
   name=`getValue $i 2`
   #��ѯ���city_nameΪcity_name��ֵ��city_nameΪ��һ�У�rowIndex���� 1
   city_name=`getValue $i 1`
   #url�к��д�����ʱ��Ҫת��
   url="https://api.yourdomain.com/api/register?params=\{\"name\":\"$name\",\"city_name\":\"$city_name\"}"
   echo $url
   result=$(curl -X GET $url)
   echo $result
   sleep 0.8
done