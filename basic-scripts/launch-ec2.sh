#!/bin/bash
#FUNCTIONS

function  create_key() 
	{ aws ec2 create-key-pair --key-name $KEYNAME --query 'Keymaterial' --output text > $KEYNAME.pem ; }

function display_key() 
	{ aws ec2 describe-key-pairs ; }

function create_sg() 
	{ aws ec2 create-security-group --group-name $SGNAME --description $SGDESC --vpc-id $VPCID ; }

function display_sg() 
	{ aws ec2 describe-security-groups ; }

function authorize_ingress() 
	{ aws ec2 authorize-security-group-ingress --group-id $SGID --protocol $PROTOCOL --port $PORT --cidr $CIDR ; } 

function display_instance() 
	{ aws ec2 describe-instances ; }

function launch_instance() 
	{ aws ec2 run-instances --image-id $AMI --count $COUNT --instance-type $INSTYPE --key-name $KEYNAME --security-group-ids $SGID --subnet-id $SUBNET ; }

#read -p "you wanna work with? 
#	1. keys
#	2. security group
#	3. instances" WORK

echo -e "\e[4;51m WELCOME TO AWS LAUNCH INSTANCE ONE TIME \e[0m"
read -p "Do you want to create a keypair (y/n): " ANSWER

if [ $ANSWER == 'y' ]
then
	read -p "Enter the name of the key: " KEYNAME
else
	echo "okay"
	exit
fi
#echo $KEYNAME.pem

############# 1. KEYPAIR

echo -e "\e[1;41m creating the key \e[0m"
create_key

echo -e "\e[1;41m listing the keypair \e0m"
display_key

echo -e "\e[3;32m Key has been downloaded to present working directory \e[0m"

############# 2. SECURITY GROUP

echo -e "\e[1;41m let's create a security group\e[0m"

read -p "Name of the SG: " SGNAME
read -p "Description for SG: " SGDESC
read -p "VPC ID for SG: " VPCID

echo -e "\e[1;41m Creating the security group... \e[0m"
create_sg
echo -e "\e[1'41m Security group created. \e[0m"
display_sg

############# 3. AUTHORIZE SECURITY INGRESS

echo -e "\e[1;41m now we have to create the inbound rule \e[0m"
read -p "Enter security group ID: " SGID
read -p "Enter protocol: " PROTOCOL
read -p "Enter the port number: " PORT
read -p "Enter your CIDR: " CIDR
echo -e "\e[1;41m GOT REQUIRED INFORMATION \e[0m"
echo -e "\e[1;41m Creating the INGRESS RULE \e[0m"
authorize_ingress
echo -e "\e[1;41m INGRESS RULE CREATED \e[0m"
echo -e "\e[1;41m Displaying updated security group \e[0m"
display_sg

############# 4. LAUNCH INSTANCE

echo -e "\e[1;41m Need some more info for launching the instance \e[0m"
read -p "Enter IMAGE ID: " AMI
read -p "Enter count: " COUNT
read -p "Enter instance type: " INSTYPE
read -p "Enter subnet ID: " SUBNET

launch_instance
echo -e "\e[1;41m Instance launched successfully \e[0m"
echo -e "\e[1;41m displaying instances \e[0m"
display_instance

############
