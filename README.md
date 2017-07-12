# DAS_IntegrationTest-K8sAuto
This repository contains DAS Integration framework source and K8s Infrastructure framework source
### DAS integration test framework ###
This is to execute test suites with using DAS cluster deployment for product-DAS

### infrastructure framework  automation ###
This repository contains infrastructure creation automation resources for a K8S cluster as below
1. Create instances in openstack - using terraform script
2. Deploy k8s cluster - using ansible scripts
3. Expose the kubernetes master URL

(1) You have to have Terrraform and Ansible setup in the client machine
Terraform : [https://www.terraform.io/intro/getting-started/install.html]
Ansible : [http://docs.ansible.com/ansible/intro_installation.html]

(2) To start the infrastructure seperately
1. First source the openrc.sh file taken from Openstack.
2. Change the terraform.tfvars file with appropriate values.
3. Run init.sh to create infrastructure and deploy the K8S cluster.
4. Run cluster-destrop.sh to destroy the cluster.
