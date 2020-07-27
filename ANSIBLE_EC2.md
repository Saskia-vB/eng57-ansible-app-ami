# Launching an EC2 instance on AWS with Ansible

# Set up
$ vagrant up ansible
$ vagrant ssh ansible

## Install Ansible and Ec2 module dependencies
$ sudo apt install python
$ sudo apt install python-pip
$ pip install boto boto3 ansible

## Create SSH keys to create to the EC2 instance after provisioning
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/my_aws

## Create the Ansible directory structure
$ mkdir -p AWS_Ansible/group_vars/all
$ cd AWS_Ansible
$ touch playbook.yml

## Create Ansible Vault file to store the AWS Access and Secret keys
$ ansible-vault create group_vars/all/pass.yml
New Vault password:
Confirm New Vault password:

## Edit the pass.yml file and create the keys global constants
$ ansible-vault edit group_vars/all/pass.yml
Vault password:
ec2_access_key: AAAAAAAAAAAAAABBBBBBBBBBBB                                      
ec2_secret_key: afjdfadgf$fgajk5ragesfjgjsfdbtirhf

## Directory Structure
➜  AWS_Ansible tree
.
├── group_vars
│   └── all
│       └── pass.yml
└── playbook.yml
2 directories, 2 files

```yaml

- hosts: localhost
  connection: local
  gather_facts: False

  vars:
    key_name: my_aws
    region: eu-west-1
    image: ami-0347e7b47c4654570 # https://cloud-images.ubuntu.com/locator/ec2/
    id: "web-app"
    sec_group: "{{ id }}-sec"

  tasks:

    - name: Facts
      block:

      - name: Get instances facts
        ec2_instance_facts:
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"
          region: "{{ region }}"
        register: result

      - name: Instances ID
        debug:
          msg: "ID: {{ item.instance_id }} - State: {{ item.state.name }} - Public DNS: {{ item.public_dns_name }}"
        loop: "{{ result.instances }}"

      tags: always


    - name: Provisioning EC2 instances
      block:

      - name: Upload public key to AWS
        ec2_key:
          name: "{{ key_name }}"
          key_material: "{{ lookup('file', '/home/vagrant/.ssh/my_aws.pub') }}"
          region: "{{ region }}"
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"

      - name: Create security group
        ec2_group:
          name: "{{ sec_group }}"
          description: "Sec group for app {{ id }}"
          # vpc_id: 12345
          region: "{{ region }}"
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"
          rules:
            - proto: tcp
              ports:
                - 22
              cidr_ip: 0.0.0.0/0
              rule_desc: allow all on ssh port
        register: result_sec_group

      - name: Provision instance(s)
        ec2:
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"
          key_name: "{{ key_name }}"
          id: "{{ id }}"
          group_id: "{{ result_sec_group.group_id }}"
          image: "{{ image }}"
          instance_type: t2.micro
          region: "{{ region }}"
          wait: true
          count: 1
          # exact_count: 2
          # count_tag:
          #   Name: App
          # instance_tags:
          #   Name: App

      tags: ['never', 'create_ec2']
```
# SSH in
## Change permissions
$ cd /etc/ssh
$ sudo nano sshd_config
- PermitRootLogin Yes
- PasswordAuthentication Yes
$ sudo passwd root
$ sudo service sshd restart
$ exit

## Change hosts file Ansible controller
$ vagrant ssh ansible
$ cd /etc/
$ sudo nano hosts
[aws_ec2]
[public_IP] ansible_connection= ssh ansible_ssh_user=root ansible_ssh_pass=[passwd]
- go to playbooks
- copy app folder to ec2
