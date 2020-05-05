---
dest: /run/config/consul/secret.hcl
mode: 0644
onrender: /usr/bin/service
---
encrypt = "{{poll "insecure" "consul_key"}}"
