log=/tmp/roboshop.log
echo -e "\e[36m<<<< creating rabbitmq >>>>>\e[0m" | tee -a ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
yum install rabbitmq-server -y &>>${log}
systemctl enable rabbitmq-server &>>${log}
systemctl start rabbitmq-server &>>${log}
rabbitmqctl add_user roboshop roboshop123 &>>${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}