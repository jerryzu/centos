# pass parameter use gen apk
pathapk=$1  # �����ⲿ����
# ȡ�������´�İ������и��Ƶ�ָ��·��
cd $baseapk  # ����output\debug ·����
apkname=$(jq -r  .[0].path  /root/.jenkins2/jobs/npl/workspace/app/build/outputs/apk/debug/output.json) # ʹ�� jq ���߽���android studio ���ɵ�json��ȡapk����
echo $apkname #��ӡ
cp $pathapk/$apkname  $pathapk/npl.apk  #����apk ������linux ����
mv -f $pathapk/npl.apk  /usr/tomcat/apache-tomcat-8.0.36/webapps/apk/ # �ƶ���tomcat ·����
java -jar /usr/local/android/qrtools/qrcode.jar url=http://10.7.0.201:8080/apk/npl.apk image=latestapk.jpg save=/usr/tomcat/apache-tomcat-8.0.36/webapps/examples/image  # ʹ�ö�ά������jar ���ɶ�ά��