# Jenkins instance in AWS

Terraform & Packer used to deploy Jenkins instance in AWS.

## Getting started

* Install terraform

```sh
wget https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip -O /tmp/terraform.zip
cd /tmp
unzip /tmp/terraform.zip -d /tmp
sudo install /tmp/terraform /usr/bin
```

* Install packer

```sh
wget https://releases.hashicorp.com/packer/1.2.2/packer_1.2.2_linux_amd64.zip -O /tmp/packer.zip
cd /tmp
unzip /tmp/packer.zip -d /tmp
sudo install /tmp/packer /usr/bin
```

* Set ssh key for keypair

```sh
ssh-keygen -t rsa -f ~/.ssh/id_rsa.jenkins -N ""
```

* Set AWS credentials, region, vpc_id & subnet_id to use

```sh
export AWS_ACCESS_KEY_ID="<your access key>"
export AWS_SECRET_ACCESS_KEY="<your secret key>"
export AWS_DEFAULT_REGION="<region>"
export VPC_ID="<vpc id>"
export SUBNET_ID="<subnet id>"
```

## Build Jenkins AMI in packer dir

```sh
./packer.sh
```

## Deploy Jenkins in terraform dir

```sh
terraform init
terraform plan -var vpc_id=$VPC_ID -var subnet_id=$SUBNET_ID
terraform apply -var vpc_id=$VPC_ID -var subnet_id=$SUBNET_ID
```
