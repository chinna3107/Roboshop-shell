nodejs(){

log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m<<<< creating mongo repo >>>>\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m<<<< installing nodejs repo >>>>\e[0m" | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m<<<< Installing nodejs >>>>\e[0m" | tee -a ${log}
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m<<<< creating roboshop user account >>>>\e[0m" | tee -a ${log}
useradd roboshop &>>${log}
echo -e "\e[36m<<<< Remove App folder  >>>>\e[0m" | tee -a ${log}
rm -rf /app &>>${log}

echo -e "\e[36m<<<< create app folder >>>>\e[0m" | tee -a ${log}
mkdir /app &>>${log}

echo -e "\e[36m<<<< Download Application content >>>>\e[0m" | tee -a ${log}
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

echo -e "\e[36m<<<< Extracting application content  >>>>\e[0m" | tee -a ${log}
cd /app &>>${log}
unzip /tmp/${component}.zip &>>${log}
cd /app &>>${log}

echo -e "\e[36m<<<< Download NodeJs Dependencies  >>>>\e[0m" | tee -a ${log}
npm install &>>${log}

echo -e "\e[36m<<<< Install Mongo client  >>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m<<<<   Load Application content >>>>\e[0m" | tee -a ${log}
mongo --host 172.31.95.239 </app/schema/${component}.js &>>${log}

echo -e "\e[36m<<<< Start ${component} service  >>>>\e[0m" | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
}
