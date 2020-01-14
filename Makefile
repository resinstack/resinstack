BASE = components/kernel.yml components/sysctl.yml $(DEBUG)
DEBUG = components/getty.yml
PERSIST = components/persist-disk.yml
DHCP = components/dhcp.yml

CONSUL_SERVER = $(BASE) $(PERSIST) $(DHCP) components/consul/consul.yml
CONSUL_SERVER_FILES = $(CONSUL_SERVER) components/consul/server.hcl

DHCP_SERVER = $(BASE) components/dhcpd/dhcpd.yml
DHCP_SERVER_FILES = $(DHCP_SERVER) components/dhcpd/dnsmasq.conf

img:
	mkdir -p img/

img/consul.qcow2: img $(CONSUL_SERVER_FILES)
	linuxkit build -format qcow2-bios -name consul -dir img/ $(CONSUL_SERVER)

img/dhcpd.qcow2: img $(DHCP_SERVER_FILES)
	docker build -t dnsmasq -f components/dhcpd/Dockerfile components/dhcpd/
	linuxkit build -format qcow2-bios -name dhcpd -dir img/ $(DHCP_SERVER)


local-img: img/consul.qcow2 img/dhcpd.qcow2

clean:
	rm -rf img/ linuxkit/
