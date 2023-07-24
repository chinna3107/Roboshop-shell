echo -e "\e[36m<<<< creating catalogue service >>>>>\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service  /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[36m<<<< creating mongo repo >>>>\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[36m<<<< installing nodejs repo >>>>\e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Installing nodejs >>>>\e[0m" | tee -a /tmp/roboshop.log
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m<<<< creating roboshop user account >>>>\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[36m<<<< Remove App folder  >>>>\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log

echo -e "\e[36m<<<< create app folder >>>>\e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Download Application content >>>>\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Extracting application content  >>>>\e[0m" | tee -a /tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Download NodeJs Dependencies  >>>>\e[0m" | tee -a /tmp/roboshop.log
npm install &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Install Mongo client  >>>>\e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[36m<<<<   Load Application content >>>>\e[0m" | tee -a /tmp/roboshop.log
mongo --host 172.31.95.239 </app/schema/catalogue.js &>>/tmp/roboshop.log

echo -e "\e[36m<<<< Start catalogue service  >>>>\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log