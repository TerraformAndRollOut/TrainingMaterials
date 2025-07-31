resource_group_name = "rg-tf-training-ex1"
virtual_network_name = "vnet-tftraining"
virtual_network_cidr = "10.0.1.0/24"
subnet_name = "snet-tftraining"
subnet_cidr = "10.0.1.0/28"
virtual_machine = {
        name = "vmwtfexample"
        size = "Standard_B2s"
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2019-Datacenter"
        version = "latest"
}
tags = {
    team = "ccoe"
    servicename = "training"
}