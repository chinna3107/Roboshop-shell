echo -e "e\[36m<<<< creating catalogue service <<<<<\e[0m"
cp catalogue.service  /etc/systemd/system/catalogue.service

echo -e "e\[36m<<<< creating mongo repo <<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "e\[36m<<<< installing nodejs repo <<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "e\[36m<<<< Installing nodejs <<<<<\e[0m"
yum install nodejs -y

echo -e "e\[36m<<<< creating roboshop user account <<<<<\e[0m"
useradd roboshop
echo -e "e\[36m<<<< Remove App folder  <<<<<\e[0m"
rm -rf /app

echo -e "e\[36m<<<< create app folder <<<<<\e[0m"
mkdir /app

echo -e "e\[36m<<<< Download Application content <<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "e\[36m<<<< Extracting application content  <<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "e\[36m<<<< Download NodeJs Dependencies  <<<<<\e[0m"
npm install

echo -e "e\[36m<<<< Install Mongo client  <<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "e\[36m<<<<   Load Application content <<<<<\e[0m"
mongo --host 172.31.95.239 </app/schema/catalogue.js

echo -e "e\[36m<<<< Start catalogue service  <<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue