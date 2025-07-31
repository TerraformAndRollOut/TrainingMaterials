# Introduction

In this exercise, you will create a virtual machine, and either create or use the supporting Azure resources needed to build one.

- Resource Group - azurerm_resource_group
- Virtual Network - azurerm_virtual_network
- Subnet - azurerm_subnet
- Network Interface -azurerm_network_interface
- Random Password - random_password
- Virtual Machine - azurerm_windows_virtual_machine
  
# Cloning the project repository
​
1. Open Visual Studio Code (VS Code).
2. If a terminal window does not load click **Terminal > New Terminal** in the top menu
3. Create a new folder called "training", and then change to that directory.
    ```
    mkdir training
    cd training
    ```
4. Go to GitLab/GitHub/ADO and find the Workshop project called project1 withing the Training Group Training / Terraform Workshop / project1
5. Copy the clone url from the project. Click the blue "Code" button and copy the "Clone with SSH" url
6. Back in VS Code, in the terminal at the bottom of your screen, use the "git clone" command, clone the "project1" repository via the terminal
    ```
    git clone git@someotherthing.com:training/terraform-workshop/project1.git
    ```
7. This will create a new folder called "project1" containing all the files needed for this exercise.
8. Using the File Explorer in VS Code, examine the file layout of the project. You will find the following files:

   - **backend.tf** - This is where any providers (things you are connecting to) are defined. This is also where any remote state definition would live. In this exercise however we will not be using remote state.

   - **main.tf** - This is the bulk of your code, where all the resources you create and data sources you reference will live.

   - **variables.tf** - This is where variable declarations go. This file is not used until session 2.

   - **terraform.tfvars** - This is where values for variables are set. This file is not used until session 2.

   - **output.tf** - This file holds any outputs, values that we would want to use in other terraform projects, or in tests. This file is not used until session 2.

   - **README.md** - This is where you would put your documentation around what the project is, what it does, how it works, etc.

   - **.gitignore** - This controls the  files, paths or extension that git will ignore when pushing code into a remote repository.

    Terraform reads ALL tf files as though its one big file. You can split up your project into as many files as you like, but the above layout is what makes the most sense for 90% of projects. Only larger projects with alot of resources might be worth splitting up by other boundaries, perhaps having a database.tf for all databse related resources, or a firewall.tf if there are alot of related firewall rules.

# Connect to Azure in the terminal
1. Log into Azure using the Cloud Academy credentials provided in the previous step.
   ```az login --use-device-code```
2. Follow the instructions in the Terminal. Copy the Code, and then click the link. Paste your code into this window, then click next.
3. Now supply your Cloud Academy student username and password that you noted down earlier.
4. Once successfully logged on you should see a json output that tells what subscription and tenant you are logged into. Make a note of the ID field value, you will need this in the next step. 
​
# Adding the provider configuration​
A Provider in Terraform is the thing you are connecting too, be that Azure, AWS, Splunk, NetApp Cloud Manager, or over 3000 other platforms/services that are currently supported. Providers come in 3 categories
- **Official** - Written by Hashicorp
- **Partner** - Written by the 3rd party vendor e.g. NetApp, or Splunk
- **Community** - Written by someone who decided that they really needed to be able to do something with service X using Terraform

A full list of providers can be found at [Terraform.io.](https://registry.terraform.io/?product_intent=terraform)
 
1. Using the link above go to Terraform.io and locate the Azure provider, and click on it.
2. Click the "Use Provider" button at the top left. this gives you the very basics that you need to configure the AzureRM provider
3. Copy the text below into your backend.tf file.
    ```
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.68.0"
        }
      }
    }

    provider "azurerm" {
      # Configuration options
      subscription_id = "your-sub-id-goes-here"
      features {}
    }
    ```
4. Update the version to the latest version shown in "Use Provider"
5. Update the subscription_id property to be the ID you made a note of in the previous step. If you didnt make a note of it, you can still find it in your terminal window in VS Code.

**The Features block is required, even though it is empty.**

A full list of all the provider options that are available can be found in the Provider documentation [here](https://registry.terraform.io/browse/providers)
​
# Terraform Init
Now that you have a provider configured you can initialize your terraform.
 
1. In your terminal window run change directory to project1 and run a terraform initialize:
    ```
    cd project1
    terraform init
    ```
2. This will initialize your project. In doing so you will see a .terraform directory has been created, as well as a .terraform.lock.hcl file within your project directory.
3. Inside the .terraform directory you will find a providers directory. This is where any providers you define in your code are downloaded to for use.
4. The .terraform directory will also be where modules are downloaded to, however modules are not covered in this workshop.
5. The .terraform.lock.hcl file is what tracks what version of the providers was used when the project was initialized. Having this file as part of your project can ensure anyone that works on your code in future is using all the same versions you where, thus making it far more likely changes will be smoother.
6. Having initialized your project, you can now run other terraform commands like validate, plan, and apply. We will do this at a later stage however.
​
# Using data sources
1. Go to the Azure Portal and look for the resource group that has been created for you, make a note of its name.
2. This Resource Group has not been created by Terraform but you will want to use, and make reference to it in your code. For this you will use a data source.
3. A Data Source is defined in Terraform in the following format:
    ```
    data "resource_type" "reference_name" {
    name = "myname"
    resource_group_name = "some-resource-group"
    }
    ```
4. The Resource Type is the type of resource you want to look for, and already exists. A full list of these can be found in the provider documentation on Terraform.io this could be a VM, a network card, a storage account, anything that the provider allows.
5. The Reference Name, is how you make references to that data sourcein your code. This is not to be confused with the name of the resource  in Azure. The standard best practice for reference name is to set the reference name to be "this", unless there is more then one of a resource in your project.
6. Return to the Azure Provider documentation on  Terraform.io and use the filter on the left hand side to search for "resource group"
7. You will notice that there are multiple matches but the two you are interested in are under the "Base" sub heading. One is an azurerm_resource_group resource, the other a data source. The resource would be used to create a resource group, the data source is used to read information from an existing one.
8. Click the Data Sources azurerm_resource_group.
9. The documentation for how to use this resource will display along with a usage example. Using the example usage is an excellent place to start when creating data source or resources for the first time. Copy and paste the example usage into your  main.tf file.
    ```
    data "azurerm_resource_group" "this" {
      name = "the-name-of-your-rg"
    }
    ```
10. Update the code to have the name of your resource group you noted earlier, and also update the reference name to "this"
11. Next you will repeat the same process but for the virtual network that is present in your resource group
12. Using Terraform.io locate the documentation for the azurerm virtual network data source, and add the code to your main.tf.
13. For the Name field you will need to enter the name of the virtual network which you can find via the Azure Portal. For the resource group name, you can use the previous data source to provide that information.
    ```
    data "azurerm_virtual_network" "this" {
      name                = "your-vnet-name"
      resource_group_name = data.azurerm_resource_group.this.name
    }
    ```
14. Building dependacies like this between datasources and resources is important for Terraform as it builds a Resource Dependancy Graph to is knows which resources, and datasources to deal with first. If you wish to learn more about the Resource Graph, you can find the documentation here
​
# Defining resources
Resources are the things you are actually going to create, and are defined in Terraform in the following format:
```
resource "resource_type" "reference_name" {
name = "myname"
resource_group_name = "some-resource-group"
setting1 = "XXXXX"
setting2 = "YYYYY"
...
}
```

The Resource Type is the type of resource you want to create, and a full list of these can be found in the provider documentation on Terraform.io this could be a VM, a network card, a storage account, anything that the provider allows.

The Reference Name, is how you make references to that resource in your code. This is not to be confused with the name of the resource your are going to create in Azure. The standard best practice for reference name is to set the reference name to be "this", unless there is more then one of a resource in your project.
 
1. Go to Terraform.io and find the azurerm_subnet resource in the Azurerm Provider documentation.
2. The usage example here has alot of things you dont actually want for this exercise, so you will type out resource definition for this resource.
3. Start with the core of the resouce block. Notice that as you type, if you have the Hashicorp Terraform VS Code extension installed, as you type resource an autocomplete option will appear. This will help guide you through the process.
4. Set the subnets resource type to be "azurerm_subnet", and set the reference name to "this"
    ```
    resource "azurerm_subnet" "this" {
    }
    ```
5. Add a name property and set it to "snet-tfworkshop-yournamehere".  Notice that once again, there is an autocomplete option. This shows that this is a required property for the resource, and that is should be of the type string, meaning whatever you type after the = sign should be in "speech marks"
6. Add a address_prefixes property and set it to be ["10.0.1.0/28"]. Again note the autocomplete options, this show that this is also a required property, and is a list of strings. The square brackets are what denotes a list in Terraform.
7. Finally add the resource group name and virtual network name references, and use the data sources you created in the previous steps.
You should end up with something like the below. The order of the properties does not matter, so long as they are all there.
    ```
    resource "azurerm_subnet" "this" {
      name                 = "snet-tfworkshop-yournamehere"
      resource_group_name  = data.azurerm_resource_group.this.name
      virtual_network_name = data.azurerm_virtual_network.this.name
      address_prefixes     = ["10.0.1.0/28"]
    }
    ```
    The square brackets used in the addess_prefixes denote a LIST, something that can take more than one value. The above is a list even though it only has one element. A good clue to if a property expects a list is that it is plural. E.g. address_prefixes, protocols, actions. If you see an "s" at the end of a property, you are going to need square brackets.
    
    Also with the Hashicorp Terraform extension installed in VS Code, you can hover over any property and see the type is expects, be it a list, string, bool, map, or tuple. More information on data types used in Terraform can be found [here](https://developer.hashicorp.com/terraform/language/expressions/types).
8. Now with one resource, and two data sources defined in your code, you can do an apply. In the Terminal window, run the following command.
    ```
    terraform plan
    ```

9. This will generate a Terraform plan. This shows you what Terraform intends to build based on your code. You only have one thing that should be being built. You should see your subnet, and data sources. It should also say in the summary "1 to add".
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    ```
      + create
    Terraform will perform the following actions:
      # azurerm_subnet.this will be created
      + resource "azurerm_subnet" "this" {
          + address_prefixes                               = [
              + "10.0.1.0/28",
            ]
          + enforce_private_link_endpoint_network_policies = (known after apply)
          + enforce_private_link_service_network_policies  = (known after apply)
          + id                                             = (known after apply)
          + name                                           = "snet-tfworkshop-kev"
          + private_endpoint_network_policies_enabled      = (known after apply)
          + private_link_service_network_policies_enabled  = (known after apply)
          + resource_group_name                            = "some-rg"
          + virtual_network_name                           = "some-vnet"
        }
    Plan: 1 to add, 0 to change, 0 to destroy.
    ────────────────────────────────────────────────────────────────────────────────────────────────────
    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
    ```

10. If this looks to be OK, you wil now do an Apply to create your subnet. Type: 
    ```terraform apply```
    The plan will run again, then type "yes".
11. Once the Apply completes, you should then see in the portal that you have created a subnet with a /28 range (16 addresses, with 5 reserved by Azure).
12. Next you will create a Windows Virtual Machine, and the Network Interface Card that connects to the subnet you have just created.
13. As before, go to Terraform.io and find the "azurerm_windows_virtual_machine" resource documentation.
    Note that the usage example has alot more things in it. This is becasue Terraform usage examples dont just give you an example of the thing  you want to build, they also show any prerequisite resource. To build a VM, you need a Resource Group, a Vnet, a Subnet, and a NIC before you can create your VM, so all of these are shown in the useage example.
14. Copy two resource blocks from the example into your main.tf, the "azurerm_network_interface", and "azurerm_windows_virtual_machine".
15. Update the reference names of both resources to be "this" as per Best Practice.
16. Update the name of the network interface to be "my-nic".
17. Now update the location, resource_group_name, and subnet_id properties to point to the existing resources and data sources in your project as below.
    ```
    resource "azurerm_network_interface" "this" {
      name                = "my-nic"
      # Note the "data." prefix when calling a data source  
      location            = data.azurerm_virtual_network.this.location    # Puts the NIC in the name region as the vnet
      resource_group_name = data.azurerm_resource_group.this.name         # Puts the NIC in the right resource group 
      ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.this.id            # No prefix when referencing a resource
        private_ip_address_allocation = "Dynamic"                         # Uses DHCP To assign an IP address
      }
    }
    ```
    Note the difference between referencing a data source and a resource. When referencing a Data Source there is a "data." prefix, however when referencing a resource, you just start with the resource type, and there is no such prefix.

18. Now update the windows virtual machine in a similar way. Update the reference name, location, resource_group_name, and network_interface_ids
    ```resource "azurerm_windows_virtual_machine" "this" {
      name                = "vmw-yournamehere"
      resource_group_name = data.azurerm_resource_group.this.name
      location            = azurerm_network_interface.this.location
      size                = "Standard_F2"
      admin_username      = "adminuser"
      admin_password      = "P@$$w0rd1234!"
      network_interface_ids = [
        azurerm_network_interface.this.id,
      ]
      os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
      }
    }```
19. Last, but by no means least, you should notice something undesireable in the above config...a plain text password. We want to remove this and provide a dynamically generated, random password. Terraform has a way to generate a random password using its random provider.
20. Locate random_password resource in the documentation link above and copy and paste the random password resource block. Update the reference name as you have with other resources. Leave everything else as is.
    ```
    resource "random_password" "this" {
      length           = 16
      special          = true
      override_special = "!#$%&*()-_=+[]{}<>:?"
    }
    ```
21. Now update the admin password field in your windows virtual machine to use this new resource.
    ```
    admin_password = random_password.this.result
    ```

22. You are now ready to try and deploy your virtual machine.

# Deploying a Virtual Machine

​
1. With your code ready to deploy, perform a terraform plan, and you should now see "3 to add" in your plan. A windows virtual machine, a network interface, and a random password.
 
...but you dont.
    ```
    │ Error: Inconsistent dependency lock file
    │ 
    │ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
    │   - provider registry.terraform.io/hashicorp/random: required by this configuration but no version is selected
    │ 
    │ To update the locked dependency selections to match a changed configuration, run:
    │   terraform init -upgrade
    ```
2. By adding the random password resource you have introduced a new provider, the random provider. Provider configuration is pulled down at the point of "terraform init". When you ran this command earlier, you had only the azurerm provider code in your project, so only the azurerm provider was downloaded.
 
Re-run a `terraform init`

3. You will see that the init output shows that the random provider is now part of your project
    ```
    Initializing the backend...
    Initializing provider plugins...
    - Finding latest version of hashicorp/random...
    - Reusing previous version of hashicorp/azurerm from the dependency lock file
    - Installing hashicorp/random vX.X.X...
    - Installed hashicorp/random vX.X.X (signed by HashiCorp)
    - Using previously-installed hashicorp/azurerm vX.XX.X
    Terraform has made some changes to the provider dependency selections recorded
    in the .terraform.lock.hcl file. Review those changes and commit them to your
    version control system if they represent changes you intended to make.
    ```

3. Look in your .terraform directory, you will also now see azurerm, and random have been downloaded.
 
Now, re-run your `terraform plan`

4. Your plan should now be successful, and show 3 resources to add.
 
5. Now that you are happy with your plan, you can run an apply to create your VM, Nic, and Password resources.  Run terraform apply and then type "yes" to run the apply tasks.
 
6. After running the apply you will be met with another error. This error is due to a policy restriction within the QA subscription that doesnt let you build any big VM's, and an F series VM breaches that policy. **A successful plan does not guarentee a successful apply.** A plan is a guide, you may hit policy violations, or permissions issues. A plan checks that the logic, and syntax of what you are trying to achieve is valid.
 
7. Now update the VM so that it doesnt violate the policy. Update the size property to an allowed SKU as below.
    ```
    size = "Standard_B2ms"
    ```

8. Now re-run your `terraform apply`, and type "yes". You should see that the resources are being created.
   
9. Congratulations, you've just created your first VM in Azure, using Terraform.
​
# Terraform State File

Now that you've got something deployed you're going to take a look at the Terraform state file that has been created.

The Terraform state file will have been created in your working directory. This file stores the config settings that Terraform has applied. This is part of how Terraform apply knows what needs to be created, updated, or deleted. The file is written in HCL which is very similar to JSON. You will find all the resources that you have created today in that file. Open it and search for the azurerm_windows_virtual_machine. You will see that all the settings for the VM are present in the state file...including the admin password.

Terraform stores all properties in the state file, including sensitive values which is why in a production deployment you dont use a local state file like you have today, but use a secured remote managed state file. Recent updates to Terraform do allow write only, and ephemeral values that are not stored in state, but only for certain providers. This helps with the problem of plain text secrets in state, but they still dont cover all secrets that you may need.

When Terraform runs, it has 3 points of reference.

- Terraform Code
- State File
- The Actual Resources
  
By comparing these 3 things it works out what it needs to do.

### Scenario 1: Creating new resouces
Terraform can see that a new resource is in your code, but doesnt exist in state, so it will decide that this resource should be created. At this point it will not check if the resource exists in the live environment. If you have an existing resource with the same resource id, the apply will fail, but you can **import** resources into state.

### Scenario 2: GUI Changes (Configuration Drift)
A change has been made in the GUI, lets say a VM size/SKU has changed. The code says it should be a Standard_B2ms, Terraform State know that when it was last run that is was a Standard_B2ms...but now when you run a plan it detects a change in the live resource and finds a Standard_D4s VM. If you do not update your code, an apply will change this setting back down to the smaller size. It may be that you WANT to shrink it, the VM shouldnt be that big, but it may be that it was changed for a reason and you need to update your code to reflect that change.

### Scenario 3: Updating existing resources
You are wanting to update some resource that already exists, lets say you want to increase the size of a disk on a virtual machine. All you need to do is update the appropriate size property in your code and when applied the disk size will increase. Be aware though, much like in VMware, you still need to take to appropriate actions at the OS level to make that increased size available to the operating system.

### Scenario 4: Deleting Resources
When deleting a resouce, or resources, you remove it from your code and run the apply just as if you were adding something. Terraform will look at the live resources, it will look at the state file and work out that it needs to remove that storage account, or that VM. The apply will show which resources its going to destroy.

# ​Redeploying a Virtual Machine
Now you have created your VM, subnet, NIC, and password, you are going to redeploy it, meaning you will destroy it and then rebuild it.
 
1. In your terminal run `terraform destroy`, read the plan and type "yes" to destroy all your resources.

2. Once the destroy is complete, if you look at your terraform state file you will find that is looking alot smaller. It should now only contain a few lines of meta data.
 
3. Now run `terraform apply`, read the plan and type "yes", this will rebuild all your resources from scratch.

You have just redeployed your project, exactly like it was the first time, and would be every time.
 
Finally, be a good digital citizen, and destory your infrastructure that you are no longer using. In Terminal type `terraform destroy`

# Summary
Congratulations, you've just created your first resources in Terraform.

1. You setup your "backend" configuration by adding providers
2. You used data source blocks to get details of existing resources
3. You used resource blocks to create new resources
4. You used multiple providers, azurerm, and the random provider
5. You've looked at the state file that gets created.

The next session will cover the following topics

- Variables
- Locals
- Looping using the **count** meta argument
- Conditional resources using **count**
- Looping using the **for_each** meta argument

If you are moving straight from Part 1 to Part 2, please ensure you have run the `terraform destroy` command.