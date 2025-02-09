#!/bin/bash
# Actualizar el sistema
sudo yum update -y

# Clonar para conseguir el dockerfile
sudo dnf install -y git
sudo mkdir /var/web
sudo mkdir /var/ldap

cd /var
sudo git clone https://github.com/ferminromero00/LDAP_TAREA.git
sudo mv LDAP_TAREA/Dockerfiles/dockerfile_web web
sudo mv LDAP_TAREA/Dockerfiles/dockerfile_ldap ldap
sudo mv LDAP_TAREA/Dockerfiles/usuario1.ldif ldap

#Instalar docker
sudo dnf install docker -y
sudo systemctl start docker

# Instalamos docker con server web
cd web
docker build -f dockerfile_web -t restaurante .
docker run -it --name restaurante -p 80:80 -p 443:443 -d restaurante

# Instalamos docker con ldap
cd /var/ldap
docker build -f dockerfile_ldap -t ldap .
docker run -it --name ldap -d -p 389:389 -p 636:636 ldap