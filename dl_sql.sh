
#!/bin/bash
# rpt_act_intfreinshare_md.sql
read -p "Enter SqlFile name: " sqlfile
echo Input File Name is: $sqlfile

# if [ -z $sqlfile ]
# then
#   echo file: $sqlfile hasn't exists!
# else
#   echo file: $sqlfile
# fi

do_svn() {
  cd /alidata/edwproject/taskfile/sql
  svn cat svn://10.19.0.22/edw/08src/alidata/edwproject/taskfile/sql/$sqlfile > $sqlfile
  ls -l  $sqlfile
}


read -p "Are you sure to continue? [y/n] " input

case $input in
        [yY]*)
                echo "sqlfile is $sqlfile"
                do_svn;
                ;;
        [nN]*)
                exit
                ;;
        *)
                echo "Just enter y or n, please."
                exit
                ;;
esac

