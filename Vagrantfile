# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-6.7"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "2"
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: "echo 'exclude=kernel*' >> /etc/yum.conf"

  config.vm.provision :chef_zero  do |chef|
    chef.add_recipe "chef_workstation::default"
    chef.add_recipe "chef_workstation::docker"
    chef.json = {
      "chef_workstation" => {
        "chefdk" => {
          "version" => "0.8.1"
        }
      }
    }
  end

  config.vm.provision "shell", path: "provision.sh"

  config.push.define "local", strategy: "local-exec" do |push|
    push.inline = "vagrant package --output chef-essentials.box"
  end

  config.push.define "remote", strategy: "atlas" do |push|
    push.app = "xpeppers/chef-essentials"
  end
end
