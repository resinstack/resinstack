dhcpd:
	$(MAKE) -C ../ img/dhcpd.qcow2
	cp ../img/dhcpd.qcow2 dhcpd.qcow2
	linuxkit run qemu -networking bridge,resin0 dhcpd.qcow2

dhcpd-clean:
	rm -rf dhcpd*

consul.qcow2:
	$(MAKE) -C ../ img/consul.qcow2
	cp ../img/consul.qcow2 consul.qcow2

consul%: consul.qcow2
	cp consul.qcow2 consul$*.qcow2
	mkdir -p consul$*.qcow2-state
	printf "06-00-00-00-00-0%d" $* > consul$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 -disk consul$*-persist.qcow2,size=100M,format=qcow2 consul$*.qcow2

consul-clean:
	rm -rf consul*

consul-join:
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.12
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.13

clean: consul-clean dhcpd-clean
