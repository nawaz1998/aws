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

echo "creating the key"
create_key

echo "listing the keypair"
display_key

############# 2. SECURITY GROUP

echo "let's create a security group"

read -p "Name of the SG: " SGNAME
read -p "Description for SG: " SGDESC
read -p "VPC ID for SG: " VPCID

echo "Creating the security group..."
create_sg
echo "Security group created."
display_sg

############# 3. AUTHORIZE SECURITY INGRESS

echo "now we have to create the inbound rule"
read -p "Enter security group ID: " SGID
read -p "Enter protocol: " PROTOCOL
read -p "Enter the port number: " PORT
read -p "Enter your CIDR: " CIDR
echo "GOT REQUIRED INFORMATION"
echo "Creating the INGRESS RULE"
authorize_ingress
echo "INGRESS RULE CREATED"
echo "Displaying updated security group"
display_sg

############# 4. LAUNCH INSTANCE

echo "Need some more info for launching the instance"
read -p "Enter IMAGE ID: " AMI
read -p "Enter count: " COUNT
read -p "Enter instance type: " INSTYPE
read -p "Enter subnet ID: " SUBNET

launch_instance
echo "Instance launched successfully"
echo "displaying instances"
display_instance

############
