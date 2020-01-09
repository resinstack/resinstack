linuxkit.img: linuxkit.yml dnsmasq.conf
	docker build -t dnsmasq .
	linuxkit build -format qcow2-bios linuxkit.yml

clean:
	rm -rf linuxkit/
	rm -f linuxkit.qcow2
