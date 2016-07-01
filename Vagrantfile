# -*- mode: ruby -*-
# vi: set ft=ruby :

$PUPPET_SERVER = "puppetserver"
$BOX = "puppetlabs/ubuntu-14.04-64-nocm"

def setup_vms(config, hostname_prefix, num_of_instances)
  (1..num_of_instances).each do |i|
    hostname = "#{hostname_prefix}-#{i}"
    config.vm.define hostname, primary: true do |v|
      v.vm.network "public_network"
      v.vm.box = $BOX
      v.vm.hostname = hostname
      v.vm.provision "shell",
                     inline: "puppet config set server #{$PUPPET_SERVER}.local --section agent && service puppet restart"
      v.vm.provider "virtualbox" do |vb|
        vb.customize ["--paravirtprovider", "kvm"]
      end
    end
  end
end

Vagrant.configure("2") do |config|

  ## Puppet Server
  config.vm.define $PUPPET_SERVER, primary: true do |v|
    v.vm.network "public_network"
    v.vm.box = $BOX
    v.vm.hostname = $PUPPET_SERVER
    v.vm.synced_folder "./src/code", "/etc/puppetlabs/code"
    config.vm.provider "virtualbox" do |vb|
      vb.customize [
                       "modifyvm", :id,
                       "--memory", "2048",
                       "--paravirtprovider", "kvm", # for linux guest
                       "--cpus", "2"
                   ]
    end
  end

  ## Webservices
  setup_vms(config, "web", 3)

  ## Zookeeper
  setup_vms(config, "zookeeper", 2)

  ## Kafka
  setup_vms(config, "kafka", 2)

  ## Logstash
  setup_vms(config, "logstash", 1)

  ## Elasticsearch
  setup_vms(config, "elasticsearch", 1)

  ## Kibana
  setup_vms(config, "kibana", 1)

end
