MD_PACKER = go run ../tools/metadata-packer/main.go

dhcpd:
	$(MAKE) -C ../ img/dhcpd.qcow2 ENABLE_GETTY=1
	cp ../img/dhcpd.qcow2 dhcpd.qcow2
	linuxkit run qemu -networking bridge,resin0 dhcpd.qcow2

dhcpd-clean:
	rm -rf dhcpd*

consul.qcow2:
	$(MAKE) -C ../ img/consul.qcow2 ENABLE_GETTY=1
	cp ../img/consul.qcow2 consul.qcow2

consul-metadata.json:
	$(MD_PACKER) --base metadata/consul-server/ --out consul-metadata.json

consul%: consul.qcow2 consul-metadata.json
	cp consul.qcow2 consul$*.qcow2
	mkdir -p consul$*.qcow2-state
	printf "06-00-00-00-00-0%d" $* > consul$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -mem 1536 -disk consul$*-persist.qcow2,size=100M,format=qcow2 -data-file consul-metadata.json consul$*.qcow2

consul-clean:
	rm -rf consul*

consul-join:
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.12
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.13

vault.qcow2:
	$(MAKE) -C ../ img/vault.qcow2 ENABLE_GETTY=1
	cp ../img/vault.qcow2 vault.qcow2

vault-metadata.json:
	$(MD_PACKER) --base metadata/vault-server/ --out vault-metadata.json

vault%: vault.qcow2 vault-metadata.json
	cp vault.qcow2 vault$*.qcow2
	mkdir -p vault$*.qcow2-state
	printf "06-00-00-00-00-1%d" $* > vault$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -mem 1536 -disk vault1$*-persist.qcow2,size=100M,format=qcow2 -data-file vault-metadata.json vault$*.qcow2

vault-clean:
	rm -rf vault*

nomad.qcow2:
	$(MAKE) -C ../ img/nomad.qcow2 ENABLE_GETTY=1
	cp ../img/nomad.qcow2 nomad.qcow2

nomad-metadata.json:
	$(MD_PACKER) --base metadata/nomad-server/ --out nomad-metadata.json

nomad%: nomad.qcow2 nomad-metadata.json
	cp nomad.qcow2 nomad$*.qcow2
	mkdir -p nomad$*.qcow2-state
	printf "06-00-00-00-00-2%d" $* > nomad$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -mem 1536 -disk nomad1$*-persist.qcow2,size=100M,format=qcow2 -data-file nomad-metadata.json nomad$*.qcow2

nomad-clean:
	rm -rf nomad*

nomad-client.qcow2:
	$(MAKE) -C ../ img/nomad-client.qcow2 ENABLE_GETTY=1
	cp ../img/nomad-client.qcow2 nomad-client.qcow2

nomad-client-metadata.json:
	$(MD_PACKER) --base metadata/nomad-client/ --out nomad-client-metadata.json

nomad-client%: nomad-client.qcow2 nomad-client-metadata.json
	cp nomad-client.qcow2 nomad-client$*.qcow2
	mkdir -p nomad-client$*.qcow2-state
	printf "06-00-00-00-00-3%d" $* > nomad-client$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -mem 1536 -disk nomad-client1$*-persist.qcow2,size=100M,format=qcow2 -data-file nomad-client-metadata.json nomad-client$*.qcow2

nomad-client-clean:
	rm -rf nomad-client*

clean: consul-clean dhcpd-clean vault-clean
