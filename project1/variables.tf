# This is where you define a variable, giving it a name, a type, a description, and sometimes a default
variable "vm_size" {
 type = string
 description = "The size of the VM. Allowed Values are Standard_B2ms, and Standard_B2"
}

variable "tags" {
 type = map(string)
 description = "The tags to be added to resources"
 default = {
  "service-name" = "training"
  "owner" = "your name"
 }
}

variable "vms" {
    type = map

}