BASE = components/kernel.yml components/sysctl.yml components/metadata.yml
GETTY = components/getty.yml
PERSIST = components/persist-disk.yml
DHCP = components/dhcp.yml
SSHD = components/sshd.yml

CONSUL_SERVER = $(BASE) $(PERSIST) $(DHCP) components/consul/consul.yml components/consul/server.yml
CONSUL_SERVER_FILES = $(CONSUL_SERVER) components/consul/base.hcl components/consul/server.hcl

CONSUL_CLIENT = components/consul/consul.yml
CONSUL_CLIENT_FILES = $(CONSUL_CLIENT) components/consul/base.hcl

DHCP_SERVER = $(BASE) components/dhcpd/dhcpd.yml
DHCP_SERVER_FILES = $(DHCP_SERVER) components/dhcpd/dnsmasq.conf

VAULT_SERVER = $(BASE) $(PERSIST) $(DHCP) components/vault/vault.yml
VAULT_SERVER_FILES = $(VAULT_SERVER) components/vault/server.hcl

NOMAD_SERVER = $(BASE) $(PERSIST) $(DHCP) components/nomad/nomad.yml components/docker.yml
NOMAD_SERVER_FILES = $(NOMAD_SERVER)

# Only enable if explicitly asked for, since it will present a root
# shell on the console with no authentication.
ifdef ENABLE_GETTY
	BASE += $(GETTY)
endif

# Only enable sshd if asked for.  These boxes are immutable, so why
# are you sshing into them?
ifdef ENABLE_SSHD
	BASE += $(SSHD)
endif

img:
	mkdir -p img/

img/consul.qcow2: img $(CONSUL_SERVER_FILES)
	linuxkit build -format qcow2-bios -name consul -dir img/ $(CONSUL_SERVER)

img/dhcpd.qcow2: img $(DHCP_SERVER_FILES)
	docker build -t dnsmasq -f components/dhcpd/Dockerfile components/dhcpd/
	linuxkit build -format qcow2-bios -name dhcpd -dir img/ $(DHCP_SERVER)

img/vault.qcow2: img $(VAULT_SERVER_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format qcow2-bios -name vault -dir img/ $(VAULT_SERVER) $(CONSUL_CLIENT)

img/nomad.qcow2: img $(NOMAD_SERVER_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format qcow2-bios -name nomad -dir img/ $(NOMAD_SERVER) $(CONSUL_CLIENT)

local-img: img/consul.qcow2 img/dhcpd.qcow2

clean:
	rm -rf img/ linuxkit/
