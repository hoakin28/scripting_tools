#!/bin/bash
echo -e "\t\t\t########################## Instalador CLI de MV para KVM ###############################\n"

VIRT_INSTALL=$(which virt-install)
IMAGE_PATH=/var/lib/libvirt/images
INTERFACE=br0
ISO_PATH=/var/lib/libvirt/iso
pattern='^([a-zA-Z0-9_-]{1,})$'
FLAG=true

if [[ ! -x $VIRT_INSTALL ]]
then
	echo "instale virt-install para continuar"
	exit 1 
fi

read -p "Nombre de la imagen a instalar: " ISO_NAME
if [ ! -e $ISO_PATH/$ISO_NAME ]
then
	echo "La imagen no existe , verifique el nombre y/o que exista en la ruta [/var/lib/libvirt/iso/]"
	exit 1
fi	

read -p "Nombre de la maquina: " MACHINE_NAME
while [[ ! $MACHINE_NAME =~ $pattern  ]]
do
	echo "El nombre contiene caracteres invalidos (solo letras y numeros)"
	read -p "Nombre de la maquina: " MACHINE_NAME
done
MACHINE_NAME=$(echo $MACHINE_NAME | iconv -f UTF-8 -t ascii//TRANSLIT//IGNORE | sed "s/[\'\~]//g")
read -p "Asignar memoria RAM en MiB: " RAM
read -p "Asignar # de CPUs: " VCPU
read -p "Desea asignar sockets y cores? [y/n]: " TMP
TMP="${TMP,,}"
while ($FLAG)
do
if [ $TMP == y ]
then
	read -p  "Asignar # de sockets: " SOCKET
	read -p  "Asignar # de cores: " CORES
	FLAG=false
elif [ $TMP == n ]
then
	FLAG=false
	continue
else 
	read -p  "Opcion no valida, escriba [y] para si y [n] para no: " TMP
fi
done

read -p "Espacio en HDD en GiB: " HDD_SIZE
read -p "Tipo de S.O. (Windows,Linux): " OS_TYPE
read -p "Distribucion (Windows7,Windows8,Debian8,Centos7): " FLAVOR


virt-install \ 
#  --connect qemu:///system \
#  --virt-type kvm \
--name $MACHINE_NAME \
--ram $RAM \
--vcpus $VCPU,sockets=$SOCKET,cores=$CORES \
--disk path=$IMAGE_PATH/$MACHINE_NAME,size=$HDD_SIZE,format=raw \
--os-type=$OS_TYPE \
--os-variant $FLAVOR \
--cdrom $ISO_PATH/$ISO_NAME \
--console pty,target_type=serial \
--network bridge=$INTERFACE \
--graphics vnc \
--autostart 


#echo -e "\t\t##### MAQUINA CREADA #####"

### Import a machine ###

#virt-install --name joker --ram 16384 --vcpu 16,sockets=4,cores=4 --os-type=linux --os-variant Debian8 --graphics vnc --network bridge=br0 --disk path=/var/lib/libvirt/images/joker.qcow2 --autostart --import

#qemu-img create -f raw $IMAGE_NAME.raw $HDD_SIZE G
