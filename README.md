# 005-Ansible para Wordpress (Webserver y DB)
Práctica Ansible
Objetivos:
- Desarrollar un playbook de ansible que instale un wordpress y una base de datos para su funcionamiento. 
- El playbook debería solucionar el problema en roles separados para la preparación del web server, de la instalación de la base de datos. Antes de proceder, se recomienda considerar los requisitos para instalar wordpress. 
- El role de la base de datos, no debe desarrollarse, en su lugar usar uno de ansible galaxy. 
- El otro role, debe desarrollarse considerando la mayor parametrización posible. 
- El playbook debe funcionar en debian, ubuntu y rocky linux / CentOS.

---
```markdown

## 📁 Estructura del Proyecto

005-wordpress-ansible/
├── ansible.cfg
├── inventory/
│ └── hosts.yml
├── playbooks/
│ ├── site.yml # Playbook principal
│ └── wordpress.yml # Playbook específico para WordPress
├── roles/
│ └── webserver/ # Rol personalizado para servidor web
├── requirements.yml # Roles y colecciones a instalar
└── group_vars/
└── all.yml # Variables comunes (credenciales, etc.)
---

## 🚀 Cómo poner en marcha el proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/matias-tecnosoul/005-wordpress-ansible.git
cd 005-wordpress-ansible
````

### 2. Instalar las dependencias

#### 📦 Roles (como `geerlingguy.mysql`)

```bash
ansible-galaxy install -r requirements.yml -p roles/
```

#### 📚 Colecciones (como `community.mysql`)

```bash
ansible-galaxy collection install -r requirements.yml
```


---

## ⚙️ Variables clave (en `group_vars/all.yml`)

```yaml
mysql_root_password: "rootpassword"
mysql_databases:
  - name: wordpress
mysql_users:
  - name: wp_user
    password: wp_pass
    priv: "wordpress.*:ALL"

wordpress_db_name: wordpress
wordpress_db_user: wp_user
wordpress_db_password: wp_pass
```

---

## 🧪 Ejecución de pruebas

ejecutar cada parte por separado usando etiquetas (`--tags`):

```bash
ansible-playbook playbooks/site.yml --limit ubuntu --tags "mysql"
ansible-playbook playbooks/site.yml --limit ubuntu --tags "webserver"
```

ejecutar todo junto:

```bash
ansible-playbook playbooks/site.yml --limit ubuntu
```

> Revisar `inventory/hosts.yml` para q apunte a una VM o host válido para testing.

---

## 🧹 Recomendar limpieza del entorno de pruebas

Para volver a correr desde cero:

* **Recrear la VM** si estás usando VirtualBox/Vagrant/libvirt
* O manualmente: borrar Apache/MySQL y archivos de WordPress en el servidor de prueba

---

## 📄 .gitignore

> Se excluyen los roles descargados con:

```
roles/geerlingguy.mysql/
```
El rol se vuelve a instalar fácilmente con:

```bash
ansible-galaxy install -r requirements.yml -p roles/
```

---

## ✅ Requisitos

* Ansible `2.14+`
* Python `3.8+`
* Acceso SSH al host definido como `ubuntu` en el inventario
* (Opcional) VirtualBox o alguna VM para testing

---
