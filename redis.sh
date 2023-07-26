log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
yum module enable redis:remi-6.2 -y &>>${log}
yum install redis -y &>>${log}
systemctl enable redis &>>${log}
systemctl restart redis &>>${log}

