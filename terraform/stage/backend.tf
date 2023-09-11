terraform {


  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    bucket   = "swenumappterraformstate"
    region   = "ru-central1"
    key      = "prod/terraform.tfstate"
    #access_key = var.id_s3_key
    #secret_key = var.secret_s3_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
