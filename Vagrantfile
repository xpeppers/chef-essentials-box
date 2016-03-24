# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-6.7"
  config.vm.hostname = "chef-essentials"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "chef-essentials"
    vb.cpus = "2"
    vb.memory = "1024"
    vb.customize ["modifyvm", :id, "--vram", "10"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  end

  config.vbguest.auto_update = true

  config.vm.provision "shell", inline: "echo '[main]\nexclude=kernel*' > /etc/yum.conf"

  config.vm.provision :chef_solo  do |chef|
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
end
