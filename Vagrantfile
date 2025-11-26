VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  worker_count = 2
  controller_memory = 4096
  worker_memory = 6144
  
  # Controler node
  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.box = "bento/ubuntu-24.04"
    ctrl.vm.box_version = "202510.26.0"
    ctrl.vm.hostname = "k8s-controller"

    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.memory = controller_memory
      vb.cpus = 1
      vb.name = "kubernetes-ctrl"
    end

    ctrl.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/general.yaml"
    end
    ctrl.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/ctrl.yaml"
    end
  end

  # Worker nodes
  (1..worker_count).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "bento/ubuntu-24.04"
      node.vm.box_version = "202510.26.0"
      node.vm.hostname = "k8s-node#{'%02d' % i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "kubernetes-node-#{i}"
        vb.memory = worker_memory
        vb.cpus = 2
      end

      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/general.yaml"
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/node.yaml"
      end
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    cat > /vagrant/inventory.cfg << 'EOF'
[controller]
192.168.56.100

[workers]
192.168.56.101
192.168.56.102

[kubernetes_cluster:children]
controller
workers
EOF
  SHELL

end