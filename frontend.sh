log=/tmp/roboshop.log
yum install nginx -y &>>${log}
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
systemctl enable nginx &>>${log}
systemctl start nginx &>>${log}
rm -rf /usr/share/nginx/html/* &>>${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
systemctl restart nginx &>>${log}