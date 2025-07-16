Vagrant.configure("2") do |config|
  
  # Ubuntu 22.04 (Jammy)
  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/jammy64"
    ubuntu.vm.hostname = "wordpress-ubuntu"
    ubuntu.vm.network "private_network", ip: "192.168.56.10"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
      vb.name = "wordpress-ubuntu"
    end
  end
  
  # Debian 12 (Bookworm)
  config.vm.define "debian" do |debian|
    debian.vm.box = "debian/bookworm64"
    debian.vm.hostname = "wordpress-debian"
    debian.vm.network "private_network", ip: "192.168.56.11"
    debian.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
      vb.name = "wordpress-debian"
    end
  end
  
  # Rocky Linux 9
  config.vm.define "rocky" do |rocky|
    rocky.vm.box = "rockylinux/9"
    rocky.vm.hostname = "wordpress-rocky"
    rocky.vm.network "private_network", ip: "192.168.56.12"
    rocky.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
      vb.name = "wordpress-rocky"
    end
  end
  
  # Configuración común para todas las VMs
  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar sistema
    if command -v apt >/dev/null 2>&1; then
      apt update
      # Instalar Python si no está (necesario para Ansible)
      apt install -y python3 python3-pip
    elif command -v yum >/dev/null 2>&1; then
      yum update -y
      yum install -y python3 python3-pip
    elif command -v dnf >/dev/null 2>&1; then
      dnf update -y
      dnf install -y python3 python3-pip
    fi
    
    # Configurar SSH para Ansible
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  SHELL
end