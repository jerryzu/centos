# pass parameter use gen apk
pathapk=$1  # 接受外部参数
# 取出来最新打的包，进行复制到指定路径
cd $baseapk  # 进入output\debug 路径下
apkname=$(jq -r  .[0].path  /root/.jenkins2/jobs/npl/workspace/app/build/outputs/apk/debug/output.json) # 使用 jq 工具解析android studio 生成的json获取apk名称
echo $apkname #打印
cp $pathapk/$apkname  $pathapk/npl.apk  #进行apk 拷贝，linux 命令
mv -f $pathapk/npl.apk  /usr/tomcat/apache-tomcat-8.0.36/webapps/apk/ # 移动到tomcat 路径下
java -jar /usr/local/android/qrtools/qrcode.jar url=http://10.7.0.201:8080/apk/npl.apk image=latestapk.jpg save=/usr/tomcat/apache-tomcat-8.0.36/webapps/examples/image  # 使用二维码生成jar 生成二维码