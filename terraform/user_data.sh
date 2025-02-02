#!/bin/bash
# Actualizar el sistema
sudo yum update -y

# Clonar para conseguir el dockerfile
sudo dnf install -y git
sudo mkdir /var/web

cd /var
sudo git clone https://github.com/ferminromero00/LDAP_TAREA.git
sudo mv Despliegue-TiendaOnline/Dockerfiles/dockerfile_web web

#Instalar docker
sudo dnf install docker -y
sudo systemctl start docker

cd web
docker build -t restaurante .
docker run -it --name restaurante -p 80:80 -p 443:443 -d restaurante


