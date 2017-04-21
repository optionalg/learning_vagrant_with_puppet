Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.define :web do |web_config|
    web_config.vm.network "private_network", ip: "192.168.50.10"

    web_config.vm.provision 'shell',
      inline: "sudo apt install puppet -y"

    web_config.vm.provision 'puppet' do |puppet|
      puppet.manifest_file = 'web.pp'
    end
  end

  config.vm.define :web2 do |web_config|
    web_config.vm.network "private_network", ip: "192.168.50.11"

    web_config.vm.provision 'shell',
      inline: "sudo apt install puppet -y"

    web_config.vm.provision 'puppet' do |puppet|
      puppet.manifest_file = 'web.pp'
    end
  end

end
