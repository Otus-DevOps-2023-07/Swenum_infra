terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.95.0"
    }
  }
}

provider "yandex" {
  token     = var.token_yc
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "vpc" {
  source         = "../modules/vpc"
  subnet_name    = "app-subnet"
  network_name   = "app-network"
  v4_cidr_blocks = ["192.168.10.0/24"]

}

module "app" {
  source                 = "../modules/app"
  public_key_path        = var.public_key_path
  app_disk_image         = var.app_disk_image
  subnet_id              = module.vpc.subnet_id
  private_key_path       = var.private_key_path
  internal_ip_address_db = module.db.internal_ip_address_db.0
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  db_disk_image    = var.db_disk_image
  subnet_id        = module.vpc.subnet_id
  private_key_path = var.private_key_path
}
