job "hello" {
  type = "service"
  datacenters = ["AIO"]

  group "app" {
    network {
      mode = "bridge"
      port "http" {
        static = 8000
        to = 8000
      }
    }

    ephemeral_disk {
      size = 15
    }

    service {
      name = "hello-world"
      port = "http"
    }

    task "hello" {
      driver = "docker"

      config {
        image = "crccheck/hello-world"
        ports = ["http"]
      }

      logs {
        max_files = 1
      }
    }
  }
}
