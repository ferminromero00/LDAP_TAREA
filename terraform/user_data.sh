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
sudo mv LDAP_TAREA/Dockerfiles/ou_empleados.ldif ldap
sudo mv LDAP_TAREA/Certificates/ca_bundle.crt web
sudo mv LDAP_TAREA/Certificates/certificate.crt web
sudo mv LDAP_TAREA/Certificates/private.key web

#Actualizar IP del DNS-EXIT
curl https://api.dnsexit.com/dns/ud/?apikey=z8Ra6giAcLhaO19L3Vy4L3729rKqY7 -d host=ldap-server.work.gd

# Instalar docker
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

# Añadimos la unidad organizativa y el usuario
docker cp ou_empleados.ldif ldap:/root/ou_empleados.ldif
docker cp usuario1.ldif ldap:/root/usuario1.ldif

# Esperar 60 segundos antes de ejecutar los comandos ldapadd
sleep 60

docker exec -it ldap /bin/bash -c "ldapadd -x -D 'cn=admin,dc=ldap-server,dc=work,dc=gd' -w admin -f /root/ou_empleados.ldif"
docker exec -it ldap /bin/bash -c "ldapadd -x -D 'cn=admin,dc=ldap-server,dc=work,dc=gd' -w admin -f /root/usuario1.ldif"