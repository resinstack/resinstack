MD_PACKER = go run ../tools/metadata-packer/main.go

dhcpd:
	$(MAKE) -C ../ img/dhcpd.qcow2
	cp ../img/dhcpd.qcow2 dhcpd.qcow2
	linuxkit run qemu -networking bridge,resin0 dhcpd.qcow2

dhcpd-clean:
	rm -rf dhcpd*

consul.qcow2:
	$(MAKE) -C ../ img/consul.qcow2
	cp ../img/consul.qcow2 consul.qcow2

consul-metadata.json:
	$(MD_PACKER) --base metadata/consul-server/ --out consul-metadata.json

consul%: consul.qcow2 consul-metadata.json
	cp consul.qcow2 consul$*.qcow2
	mkdir -p consul$*.qcow2-state
	printf "06-00-00-00-00-0%d" $* > consul$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -disk consul$*-persist.qcow2,size=100M,format=qcow2 -data-file consul-metadata.json consul$*.qcow2

consul-clean:
	rm -rf consul*

consul-join:
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.12
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.13

vault.qcow2:
	$(MAKE) -C ../ img/vault.qcow2
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

clean: consul-clean dhcpd-clean vault-clean
