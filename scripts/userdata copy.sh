# #!/bin/bash
# yum update -y
# yum install -y httpd
# systemctl start httpd.service
# systemctl enable httpd.service
# echo "<center><h1>Hello world!</h1></center>" >> /var/www/html/index.html
# # Install cloudwatch agent and send logs to the cloudwatch log group
# sudo yum install awslogs -y
# #sudo sed -i "s/.*region = us-east-1/region = eu-west-1/g" /etc/awslogs/awscli.conf
# sudo sed -i "s/.*file = \/var\/log\/messages/file = \/var\/log\/httpd\/access_log/g" /etc/awslogs/awslogs.conf
# sudo service awslogsd start
# sudo systemctl  enable awslogsd


#!/bin/bash
# Hardware requirements: AWS Linux 2 with mimum t2.micro type instance & port 8080(application port), 9100 (node-exporter port) should be allowed on the security groups
# setup for the ansible configuration
sudo yum update –y
sudo useradd ansadmin
sudo passwd ansadmin
sudo echo ansadmin:ansadmin | chpasswd
sudo sed -i "s/.*PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart
sudo echo "%wheel  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sudo service sshd restart
sudo usermod -aG wheel ansadmin

# tomcat installations
sudo amazon-linux-extras install tomcat8.5 -y
sudo systemctl enable tomcat
sudo systemctl start tomcat

# node-exporter installations
sudo useradd --no-create-home node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xzf node_exporter-1.0.1.linux-amd64.tar.gz
sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64

# setup the node-exporter dependencies
sudo yum install git -y
sudo git clone -b installations https://github.com/cvamsikrishna11/devops-fully-automated.git /tmp/devops-fully-automated
sudo cp /tmp/devops-fully-automated/prometheus-setup-dependencies/node-exporter.service /etc/systemd/system/node-exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter


echo "<center><h1>Hello world!</h1></center>" >> /var/www/html/index.html
# Install cloudwatch agent and send logs to the cloudwatch log group
sudo yum install awslogs -y
#sudo sed -i "s/.*region = us-east-1/region = eu-west-1/g" /etc/awslogs/awscli.conf
sudo sed -i "s/.*file = \/var\/log\/messages/file = \/var\/log\/httpd\/access_log/g" /etc/awslogs/awslogs.conf
sudo service awslogsd start
sudo systemctl  enable awslogsd
