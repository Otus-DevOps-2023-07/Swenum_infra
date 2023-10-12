output "external_ip_address_app" {
  value = module.app.external_ip_address_app
}
output "external_ip_address_db" {
  value = module.db.external_ip_address_db
}

output "internal_ip_address_app" {
  value = module.app.internal_ip_address_app
}
output "internal_ip_address_db" {
  value = module.db.internal_ip_address_db
}



### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      ip_address_app = module.app.external_ip_address_app
      ip_address_db  = module.db.external_ip_address_db
      internal_ip_db = module.db.internal_ip_address_db

    }
  )
  filename = "../../ansible/environments/prod/inventory.yml"
}
### The Ansible inventory vars
resource "local_file" "AnsibleInventoryVars" {
  content = templatefile("app.tmpl",
   {

     internal_ip_db = module.db.internal_ip_address_db

   }
 )
  filename = "../../ansible/environments/prod/group_vars/app"
}
