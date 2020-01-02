box.img: linuxkit.yml
	linuxkit build -format=qcow2-bios linuxkit.yml
	mv linuxkit.qcow2 box.img

consul.box: Vagrantfile metadata.json box.img
	tar cvzf consul.box ./metadata.json ./Vagrantfile ./box.img

clean:
	rm -rf consul.box box.img linuxkit.qcow2 linuxkit/ box.img-state

box-import: consul.box
	vagrant box add --force --name consul consul.box

all: box-import
