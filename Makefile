BASE = components/kernel.yml components/sysctl.yml components/dhcp.yml components/metadata.yml components/emissary.yml components/acpi.yml
GETTY = components/getty.yml
PERSIST = components/persist-disk.yml
SSHD = components/sshd.yml
DOCKER = components/docker.yml

CDNS = components/coredns/coredns.yml
CDNS_FILES = components/coredns/Corefile components/coredns/resolv.cluster

CONSUL_SERVER = $(BASE) $(PERSIST) $(CDNS) components/consul/consul.yml components/consul/server.yml
CONSUL_SERVER_FILES = $(CONSUL_SERVER) $(CDNS_FILES) components/consul/25-base.hcl components/consul/40-server.hcl

CONSUL_CLIENT = $(CDNS) components/consul/consul.yml
CONSUL_CLIENT_FILES = $(CONSUL_CLIENT) $(CDNS_FILES) components/consul/25-base.hcl

DHCP_SERVER = components/kernel.yml components/syctl.yml components/dhcpd/dhcpd.yml
DHCP_SERVER_FILES = $(DHCP_SERVER) components/dhcpd/dnsmasq.conf

VAULT_SERVER = $(BASE) $(PERSIST) components/vault/vault.yml
VAULT_SERVER_FILES = $(VAULT_SERVER) components/vault/40-server.hcl

NOMAD_SERVER = $(BASE) $(PERSIST) $(DOCKER) components/nomad/nomad.yml components/nomad/server.yml
NOMAD_SERVER_FILES = $(NOMAD_SERVER) components/nomad/25-base.hcl components/nomad/40-server.hcl

NOMAD_CLIENT = $(BASE) $(PERSIST) $(DOCKER) components/nomad/nomad.yml components/nomad/client.yml
NOMAD_CLIENT_FILES = $(NOMAD_CLIENT) components/nomad/25-base.hcl components/nomad/40-client.hcl

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

# Though not really something you should do without reason, its often
# useful to be able to schedule workloads on the control machines with
# nomad.
ifdef ENABLE_CONTROL_NOMAD
	CONSUL_SERVER += $(NOMAD_CLIENT)
	CONSUL_SERVER_FILES += $(NOMAD_CLIENT_FILES)
	VAULT_SERVER += $(NOMAD_CLIENT)
	VAULT_SERVER_FILES += $(NOMAD_CLIENT_FILES)
	NOMAD_SERVER += $(NOMAD_CLIENT)
	NOMAD_SERVER_FILES += $(NOMAD_CLIENT_FILES)
endif

# This makes the list of files passed through it unique while
# maintaining ordering.  This is necessary for certain roles that
# apply the same service configuration multiple times with the same
# filename.
DEDUP = | tr ' ' '\n' | awk '!x[$$0]++' | tr '\n' ' '

# If running on AWS you need to set the bucket to upload to for
# staging.
AWS_BUCKET ?= linuxkit-import
AWS_AMI_NAME ?= resinstack

img:
	mkdir -p img/

img/consul.qcow2: img $(CONSUL_SERVER_FILES)
	linuxkit build -format qcow2-bios -name consul -dir img/ $(shell echo $(CONSUL_SERVER) $(DEDUP))

img/dhcpd.qcow2: img $(DHCP_SERVER_FILES)
	docker build -t dnsmasq -f components/dhcpd/Dockerfile components/dhcpd/
	linuxkit build -format qcow2-bios -name dhcpd -dir img/ $(DHCP_SERVER)

img/vault.qcow2: img $(VAULT_SERVER_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format qcow2-bios -name vault -dir img/ $(shell echo $(VAULT_SERVER) $(CONSUL_CLIENT) $(DEDUP))

img/nomad.qcow2: img $(NOMAD_SERVER_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format qcow2-bios -name nomad -dir img/ $(shell echo $(NOMAD_SERVER) $(CONSUL_CLIENT) $(DEDUP))

img/nomad-client.qcow2: img $(NOMAD_CLIENT_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format qcow2-bios -name nomad-client -dir img/ $(shell echo $(NOMAD_CLIENT) $(CONSUL_CLIENT) $(DEDUP))

img/aio.qcow2: img $(NOMAD_SERVER_FILES) $(CONSUL_SERVER_FILES) $(VAULT_SERVER_FILES)
	linuxkit build -format qcow2-bios -name aio -dir img/ $(shell echo $(NOMAD_SERVER) $(CONSUL_SERVER) $(VAULT_SERVER) $(DEDUP))

aws:
	mkdir -p aws/

aws/aio.raw: aws $(NOMAD_SERVER_FILES) $(CONSUL_SERVER_FILES) $(VAULT_SERVER_FILES)
	linuxkit build -format aws -name aio -dir aws/ $(shell echo $(NOMAD_SERVER) $(CONSUL_SERVER) $(VAULT_SERVER) $(DEDUP))

aws/aio-push: aws/aio.raw
	linuxkit push aws -bucket $(AWS_BUCKET) -timeout 1200 -img-name $(AWS_AMI_NAME) aws/aio.raw

aws/nomad-client.raw: aws $(NOMAD_CLIENT_FILES) $(CONSUL_CLIENT_FILES)
	linuxkit build -format aws -name nomad-client -dir aws/ $(shell echo $(NOMAD_CLIENT) $(CONSUL_CLIENT) $(DEDUP))

aws/nomad-client-push: aws/nomad-client.raw
	linuxkit push aws -bucket $(AWS_BUCKET) -timeout 1200 -img-name $(AWS_AMI_NAME) aws/nomad-client.raw

local-img: img/consul.qcow2 img/dhcpd.qcow2 img/nomad.qcow2 img/nomad-client.qcow2

clean:
	rm -rf img/ aws/ linuxkit/

.PHONY: clean aws/awio-push
