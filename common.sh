#Componenet Loading
func_apppreq() {
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

}

#Services start
func_systemd() {
echo -e "\e[36m<<<< Start ${component} service  >>>>\e[0m" | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
}

#NodeJS Creation
func_nodejs() {
echo -e "\e[36m<<<< installing nodejs repo >>>>\e[0m" | tee -a ${log}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m<<<< Installing nodejs >>>>\e[0m" | tee -a ${log}
yum install nodejs -y &>>${log}
}

func_mongoclient() {
#if [ "{schema_type}" == "mongodb" ]; then
echo -e "\e[36m<<<< Install Mongo client  >>>>\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m<<<<   Load Application schema >>>>\e[0m" | tee -a ${log}
mongo --host mongodb.devops-tools.online </app/schema/${component}.js &>>${log}
#fi

}

#Catalogue Creation
func_catalogue() {

log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m<<<< creating mongo repo >>>>\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

func_nodejs

func_apppreq

echo -e "\e[36m<<<< Download NodeJs Dependencies  >>>>\e[0m" | tee -a ${log}
npm install &>>${log}

func_systemd

func_mongoclient


}

func_user() {

log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[36m<<<< creating mongo repo >>>>\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

func_nodejs

func_apppreq

echo -e "\e[36m<<<< Download NodeJs Dependencies  >>>>\e[0m" | tee -a ${log}
npm install &>>${log}

func_mongoclient

func_systemd

}

func_cart() {

log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

func_nodejs

func_apppreq

echo -e "\e[36m<<<< Download NodeJs Dependencies  >>>>\e[0m" | tee -a ${log}
npm install &>>${log}

func_systemd

}

func_shipping() {
  log=/tmp/roboshop.log
  echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
  cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

yum install maven -y &>>${log}

  func_apppreq

cd /app &>>${log}
mvn clean package &>>${log}
mv target/shipping-1.0.jar shipping.jar &>>${log}

func_systemd
yum install mysql -y &>>${log}
mysql -h mysql.devops-tools.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${log}

}

func_payment() {
  log=/tmp/roboshop.log
  echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
  cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

yum install python36 gcc python3-devel -y &>>${log}

func_apppreq

cd /app &>>${log}
pip3.6 install -r requirements.txt &>>${log}

func_systemd

}

func_dispatch() {
  log=/tmp/roboshop.log
  echo -e "\e[36m<<<< creating ${component} >>>>>\e[0m" | tee -a ${log}
  cp ${component}.service  /etc/systemd/system/${component}.service &>>${log}

  yum install golang -y &>>{log}

  func_apppreq

  cd /app &>>{log}
  go mod init dispatch &>>{log}
  go get &>>{log}
  go build &>>{log}

func_systemd
}