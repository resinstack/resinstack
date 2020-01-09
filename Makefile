box_consul := boxes/consul
box_dhcpd := boxes/dhcpd

boxes := $(box_dhcpd) $(box_consul)

$(boxes):
	$(MAKE) -C $@ $(TARGET)

all: $(boxes)

.PHONY: all $(boxes)
