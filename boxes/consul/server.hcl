server = true
ui = true
data_dir = "/consul/data"
bootstrap_expect = 3
client_addr = "127.0.0.1 {{ GetPrivateInterfaces | sort \"default\" | join \"address\" \" \" }}"
