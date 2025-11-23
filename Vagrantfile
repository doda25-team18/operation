VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  worker_count = 2
  controller_memory = 4096
  worker_memory = 6144
  
  #Controler node
  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.box = "bento/ubuntu-24.04"
    ctrl.vm.hostname = "ctrl"

    ctrl.vm.network "private_network", ip: "192.168.56.100"
    
    #VirtualBox
    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = controller_memory
      vb.cpus = 1
      vb.name = "kubernetes-ctrl"
    end
  end
  
  # Worker nodes
  (1..worker_count).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "bento/ubuntu-24.04"
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.10#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.memory = worker_memory
        vb.cpus = 2
        vb.name = "kubernetes-node-#{i}"
      end
    end
  end
end