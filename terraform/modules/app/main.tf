resource "yandex_compute_instance" "app" {
  name = "reddit-app"
  labels = {
    tags = "reddit-app"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys     = "appuser:${file(var.public_key_path)}"
    user-data    = "#cloud-config\nusers:\n  - name: appuser\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzbZxD8hTETvFCn51PFT7VcBvUNhUR1bvwZJH/6FNDo4iyncCLWx9hSt8UfhDXv3zsWN5B8lfULsjhiEGG059c4stEQmPA/jrGJudmEWbEs+k66eo1p55QXFBVtd1IvapXW/j22z8t+FUqPxCoHn97LoJiS1q0pSQQxIk5+sCIfMzn/bxrKKnitokbwvO5Qik9tautttL0AVle9zCPFVw4kXzr47hpP1dh2f+rhnGUTIxQ7LZ2hE+Sd0ctP0PfPI7RbBWDQUcv38c+M7xucYH1wBqJSiDUgFbJTJt1RF2BB21MdFhCEc9GHKpW4Wpi0/Q9yHwbiyifwLzddZw+mMcXgXHoHtgUFnZO/cjwb+2qk0uVRZxUi1Qh9/smF8nWImtphJCwiA1G+K7kA/EAZ7pV4dk9InRvBIVNMkOr2M3igZzD8krVhnSQ7Sl/r1pRxc1hmMAs3dp6MjFEeljCcc6ux78iRrlcwdPXNtAEGaL2KaSyBWOTDrrddelM6HO9boM= root@by-test\n"
  }
  connection {
    type        = "ssh"
    host        = self.network_interface.0.nat_ip_address
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = templatefile("../modules/app/files/puma.service", { internal_ip_address_db = "${var.internal_ip_address_db}" })
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "../modules/app/files/postinstall_app.sh"
  }
}
