# Live Demo Cluster

This directory contains everything you need to be able to stand up a
local demo cluster.

To run the things in this directory, you must first create a bridge
device that you are allowed to use with qemu.  On linux this can be
done by running `ip link add resin0 type bridge` and adding `allow
resin0` to your qemu bridge configuration file.

Once this is done you should bring up the dhcpd server with `make
dhcpd` in a terminal.  This will bring up a DHCP server on the bridge,
once the server finishes booting you should instruct your host OS to
obtain an address for the bridge.

Next you can bring up the consul servers by running `make consulN`
where `N` is a number from 1 to 3 (you will need 3 terminals to do
this).  The consul servers are configured to automatically find each
other and the cluster will automatically bootstrap as the 3rd server
joins.  You can confirm the status of the cluster by navigating to
[the dashboard](http://192.168.10.11:8500).

Next up you can boot a vault server if you'd like by using `make
vaultN` with `N` being a number between 1 and 3.  It is not required
to have a vault server running in your cluster, but it is provided for
completeness and testability of the rest of the system.

A Nomad server can be brought up wth `make nomad1`.  Nomad will
automatically bootstrap itself as a single node cluster.  Once this
bootstrapping completes you can navigate to [the
dashboard](http://192.168.10.17:4646).  If you set
`ENABLE_CONTROL_NOMAD` when you built your machine images, you'll see
the nomad agents from the consul cluster here registered as the
`RESIN0` datacenter.

Finally, you can boot up to 10 nomad clients which run just nomad and
docker.  These clients can be booted with `make nomad-clientN` where
`N` is a number between 0 and 9.
