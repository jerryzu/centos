#!/bin/bash
#author bollenv@qq.com 2018-02-05
#查询数据库并将查询结果做参数发送HTTP请求
#SQL查询结果列数
columnNum=2
#通过参数行数和行索引位置
function getValue(){
  #调用方法传入的第一个参数，$0 表示方法名
  colIndex=$1
  #调用方法传入的第二个参数
  rowIndex=$2
  #定位到指定行，数组索引0为第一个元素
  #数学算术运算使用 $((a+b))
  idx=$(($columnNum*$colIndex+$rowIndex-1))
  #判读索引值是否大于结果行数
  #${#arrays_name[@]}获取数组长度
  if [ $idx -le ${#user_attrs[@]} ]; then
    echo ${user_attrs[$idx]}
  fi
}
#数据库查询结果，结果为每行从左到右每个单元格为一行（首行为SQL查询结果的列名）
#数组默认分割符号是空格，当查询结果中包含空格字符时，会导致一个字段被分割开，例如：create_time 2017-01-01 12:12:12 会变成两条 
#2017-01-01
#12:12:12
#因此，IFS=$'\t'采用tab来分割字段的值
#mysql -u 用户名 -p 密码 -h 主机host 数据库名 -e 执行脚本内容
IFS=$'\t'
user_attrs=(`mysql -udb_user -pdb_pwd -hdb_host dbname -e 'SELECT \`city_name\`,\`name\` FROM t_user"'`)
#循环遍历查询结果行数
for (( i=$columnNum; i<=${#user_attrs[@]}; i=i+1))
do
   #查询结果name为参数name的值，name为第二列，rowIndex传入 2
   #调用方法需要用``包上
   name=`getValue $i 2`
   #查询结果city_name为city_name的值，city_name为第一列，rowIndex传入 1
   city_name=`getValue $i 1`
   #url中含有大括号时需要转义
   url="https://api.yourdomain.com/api/register?params=\{\"name\":\"$name\",\"city_name\":\"$city_name\"}"
   echo $url
   result=$(curl -X GET $url)
   echo $result
   sleep 0.8
done