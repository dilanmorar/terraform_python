# Terraform for python app
This terraform code will generate an instance, in AWS in the region eu-west-1, using an AMI (which already has the app and dependencies installed onto it). It will create a VPC, internet gateway, route table (with association), subnets and security groups.

## Start up an instance
First change the key_name.pem that you have on your computer in the variables.tf
Then in the terraform folder run the following code on the command line:
`terraform init`
`terraform plan`
`terraform apply`

## Running the app
Using the key_name specified in varaibles and ip generated from the instance enter the machine by running the following code into the command line:
`ssh -i ~/.ssh/key_name ubuntu@xxx.xxx.xxx.xxx`
`cd app`
To run the app:
`python3 main.py`
To access data created from using the app:
`cd ../Downloads`
`cat ItJobsWatchTop30.csv`
