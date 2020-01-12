dhcpd:
	$(MAKE) -C ../boxes/dhcpd
	cp ../boxes/dhcpd/linuxkit.qcow2 dhcpd.qcow2
	linuxkit run qemu -networking bridge,resin0 dhcpd.qcow2

dhcpd-clean:
	rm -rf dhcpd*

consul.qcow2:
	$(MAKE) -C ../boxes/consul
	cp ../boxes/consul/linuxkit.qcow2 consul.qcow2

consul%: consul.qcow2
	cp consul.qcow2 consul$*.qcow2
	mkdir -p consul$*.qcow2-state
	printf "06-00-00-00-00-0%d" $* > consul$*.qcow2-state/mac-addr
	linuxkit run qemu -networking bridge,resin0 consul$*.qcow2

consul-clean:
	rm -rf consul*

consul-join:
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.12
	CONSUL_HTTP_ADDR=http://192.168.10.11:8500 consul join 192.168.10.13

clean: consul-clean dhcpd-clean
