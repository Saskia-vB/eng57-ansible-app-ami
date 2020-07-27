# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# Listing Plugins
# plugins = ['vagrant-hostsupdater']

# Executing Plugins
# plugins.each do |plugin|
# 	exec "vagrant "
# end

# Vagrant
Vagrant.configure("2") do |config|
	# Web Virtual Machine
	config.vm.define "web" do |web|
		web.vm.box = "ubuntu/xenial64"
		web.vm.network :private_network, ip: "192.168.0.10"
		web.vm.hostname = "web"
		# Provisioning with vagrant is faster for local environment
		web.vm.synced_folder "web-app", "/home/ubuntu/web-app"
		web.hostsupdater.aliases = ["development.web"]
	end
	# DB Virtual Machine
	config.vm.define "db" do |db|
		db.vm.box = "ubuntu/xenial64"
		db.vm.network :private_network, ip: "192.168.0.20"
		db.vm.hostname = "db"
		# db.hostsupdater.aliases = ["development.db"]
	end
#	AWS Virtual Machine
	config.vm.define "aws" do |aws|
		aws.vm.box = "ubuntu/xenial64"
		aws.vm.network :private_network, ip: "192.168.0.30"
		#aws.vm.network :private_network, ip: "3.249.6.201"
		aws.vm.hostname = "aws"
		aws.hostsupdater.aliases = ["development.aws"]
	end
#	Ansible Virtual Machine
	config.vm.define "ansible" do |ansible|
		ansible.vm.box = "ubuntu/xenial64"
		ansible.vm.provision "shell", path: "ansible-provision.sh"
		ansible.vm.synced_folder "ansible", "/home/ubuntu/ansible"
		ansible.vm.synced_folder "web-app", "/home/ubuntu/web-app"
		ansible.vm.synced_folder "tests", "/home/ubuntu/tests"
		ansible.vm.network :private_network, ip: "192.168.0.40"
		ansible.vm.hostname = "ansible"
		ansible.hostsupdater.aliases = ["development.ansible"]
	end
end
