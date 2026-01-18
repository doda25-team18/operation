VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  worker_count = 2
  controller_memory = 4096
  worker_memory = 6144

  # Shared folder for A3 (excellent)
  config.vm.synced_folder "./shared", "/mnt/shared",
    create: true,
    owner: "vagrant",
    group: "vagrant",
    mount_options: ["dmode=777", "fmode=777"]

  # Controller node
  config.vm.define "ctrl" do |ctrl|
    ctrl.vm.box = "bento/ubuntu-24.04"
    ctrl.vm.box_version = "202510.26.0"
    ctrl.vm.hostname = "ctrl"
    ctrl.vm.network "private_network", ip: "192.168.56.100"

    ctrl.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-ctrl"
      vb.memory = controller_memory
      vb.cpus = 2
    end

    ctrl.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/general.yaml"
      ansible.extra_vars = { worker_count: worker_count }
    end
    ctrl.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/ctrl.yaml"
      ansible.extra_vars = { worker_count: worker_count }
    end
  end

  # Worker nodes
  (1..worker_count).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "bento/ubuntu-24.04"
      node.vm.box_version = "202510.26.0"
      node.vm.hostname = "node-#{i}"
      node.vm.network "private_network", ip: "192.168.56.#{100 + i}"

      node.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-node-#{i}"
        vb.memory = worker_memory
        vb.cpus = 2
      end

      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/general.yaml"
        ansible.extra_vars = { worker_count: worker_count }
      end
      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/node.yaml"
        ansible.extra_vars = { worker_count: worker_count }
      end
    end
  end

  # EX Feature: Vagrant generates a valid inventory.cfg done with help of ai
  config.vm.provision "shell", inline: <<-SHELL_SCRIPT
    cat > /vagrant/inventory.cfg << 'EOF'
[ctrl]
192.168.56.100

[workers]
#{ (1..worker_count).map { |i| "192.168.56.#{100 + i}" }.join("\n") }

[kubernetes_cluster:children]
ctrl
workers
EOF
  SHELL_SCRIPT
end
