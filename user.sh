cp mongo.repo /etc/yum.repos.d/mongo.repo
cp user.service /etc/systemd/system/user.service
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app
npm install
systemctl enable user
systemctl start user
yum install mongodb-org-shell -y
mongo --host monogodb.devops-tools.online </app/schema/user.js
systemctl restart user