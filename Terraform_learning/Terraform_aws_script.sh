# Script to install Terraform and aws in a Python container
cd /tmp
apk add curl sudo
curl -o Terraform.zip "https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_386.zip"
unzip Terraform.zip
mv terraform /usr/local/bin/
rm -rf Terraform.zip
terraform version
cd /root
sudo python -m pip install awscli
aws --version
aws configure
# Export the variables
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=