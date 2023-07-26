log=/tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
yum install mongodb-org -y &>>${log}
systemctl enable mongod &>>${log}
systemctl start mongod &>>${log}
systemctl restart mongod &>>${log}