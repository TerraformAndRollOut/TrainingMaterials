# This is where you set values for variables
vm_size = "Standard_B2ms"

tags = {
    service-name = "training"
    owner = "your name"
    extra-tag = "foo"
    }

vms = {
  vm1 = { name = "vmwin01", size = "Standard_B2ms" }
  vm2 = { name = "vmwin02", size = "Standard_B2ms" }
}