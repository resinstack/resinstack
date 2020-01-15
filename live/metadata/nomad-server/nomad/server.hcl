datacenter = "RESIN0"
data_dir = "/var/persist/nomad"
log_level = "TRACE"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
}
