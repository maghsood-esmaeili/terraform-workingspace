output "address" {
    value = module.data_store.address
    description = "This is Mysql address to access"
}
output "port" {
    value = module.data_store.port
    description = "This is Mysql port to access"
}