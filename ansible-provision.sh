sudo apt-get update

sudo apt-get upgrade -y

sudo apt-add-repository ppa:ansible/ansible

sudo apt-get update

sudo apt-get install ansible -y

sudo echo "[web]" >> /etc/ansible/hosts

sudo echo "192.168.0.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts

sudo echo "[db]" >> /etc/ansible/hosts

sudo echo "192.168.0.20 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts

sudo echo "[aws]" >> /etc/ansible/hosts

sudo echo "192.168.0.30 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts
#sudo echo "3.249.6.201 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /etc/ansible/hosts

sudo echo "host_key_checking = False" >> /etc/ansible/ansible.cfg
