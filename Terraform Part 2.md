# Intro
Covering variables, locals, looping, and conditional resources.

# Recap
In the previous session you used 2 data sources and created 3 resources. You used a data source to get information about a resource group to organize our Azure resources. You also used a data source to get information about the virtual network (Vnet). You then used this information to deploy a subnet within that Vnet, and added a Network Interface Card (NIC) to your configuration. You created a random password and finally, you created a Windows Virtual Machine (VM).

Today you will use your original code and expand on that configuration, adding variables, locals and learning the two ways you can create multiple resources, Count and For_Each.

# Prepare the Environment
​
1. Open VS Code, in the terminal navigate to the "project1" folder from the previous session
 
2. In the terminal log into Azure using your QA credentials you should have noted in the previous steps.
    ```
    az login --use-device-code
    ```

3. Follow the instructions in the Terminal. Copy the Code, and then click the link. Paste your code into this window, then click next.
 
4. Now supply your Cloud Academy student username and password that you noted down earlier.
 
5. Once successfully logged on you should see a json output that tells what subscription and tenant you are logged into. Make a note of the ID field value, you will need this in the step 7. 
 
6. Next, because these training environments are created dynamically, you may need to make 3 small tweaks to your previous code.
 
7. Open your backend.tf file and update the subscription_id in the azurerm provider if it has changed since the last session.
    ```
    provider "azurerm" {
      # Configuration options
      subscription_id = "your-sub-id-goes-here"
      features {}
    }
    ```

8. Open your main.tf file and update the data blocks that point to the resource group and virtual network if the name of these has changed. You can find these names in the Azure Portal using your QA credentials.
    ```
    data "azurerm_resource_group" "this" {
      name = "the-name-of-your-rg"
    }
    data "azurerm_virtual_network" "this" {
      name                = "your-vnet-name"
      resource_group_name = data.azurerm_resource_group.this.name
    }
    ```

9. You should now be able to spin up the VM from the previous session with a terraform apply command to recreate the resources you had in the previous session.
terraform apply

10. After the apply has completed you should be able to see your resources in the Azure Portal. 
    
    If you receive an error stating that "Planning Failed" and that "the scope is invalid" you didnt run the terraform destroy from the end of the last session.
 
    If this is the case, delete the following files/folders from your project:
    - .terraform.lock.hcl
    - terraform.tfstate
    - terraform.tfstate.backup
    - .terraform directory

    Then run `terraform init`, which will recreate these files and folders
​
# What are Variables?
​
Variables allow you to make code that is flexible and reusable. The use of variables allows you to customize Terraform configurations without altering the main code. This is especially useful when you need to apply the same configuration in different environments (like test, preprod, and production) with different values.

Instead of having a resource name or settings as an inline string, its can be substituted for a reference to a variable. E.g. Instead of having:

```
resource "azurerm_windows_virtual_machine" "this" {
 name = "thisismyvm"
 ...
}
```

You would have:

```
resource "azurerm_windows_virtual_machine" "this" {
 name = var.vmname
 ...
}
```
You wouldn't set everything to be a variable, just the things that you want to easily be able to change in your code, or change for different environments. Today you will initially define two variables to control details in your deployment, these will be vm_size and tags.

# Defining Variables
​
1. In VS Code, open the file called variables.tf
 
2. Within the file type the following: vari
   
    As you type the above the Hashicorp Terraform extension will make an autocomplete suggestion for a variable block, click it (or press tab) to auto complete.
 
    It should auto complete to this:
    ```
    variable "" {
      
    }
    ```

3. Give this new variable a name, call it "vm_size"
    ```
    variable "vm_size" {
          
    }
    ```
 
4. You then need to define a "type". 
    ```
    variable "vm_size" {
      type = string
    }
    ```

5. The vm size will be text, which means we define it as a string. Terraform has 6 types.
 
   - string: a sequence of Unicode characters representing some text, like "hello".
   - number: a numeric value. The number type can represent both whole numbers like 15 and decimal values like 6.283185.
   - bool: a boolean value, either true or false. bool values can be used in conditional logic.
   - list (or tuple): a sequence of values, like ["us-west-1a", "us-west-1c"]. Identify elements in a list with consecutive whole numbers, starting with zero.
   - set: a collection of unique values that do not have any secondary identifiers or ordering.
   - map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}.

    Details on all of these can be found here: Types and Values - Configuration Language | Terraform | HashiCorp Developer

6. Next you need to set a description
    ```
      variable "vm_size" {
        type = string
        description = "The size of the VM. Allowed Values are Standard_B2ms, and Standard_B2"
      }
      ```

    Ensure that all variables have meaningful descriptions that explain their purpose and usage. Good documentation is essential. Good descriptions in variables can also be used to write some of your documentation automatically using tools like terraform-docs which will be covered in Part 3 of the Terraform Workshops.

7. You can also set a default value for variables. For the vm_size variable DONT set one,  you will set a default value on the tags variable instead.
 
8. There are three other options that can be set on a variable that are more advanced. They will be mentioned here for completeness, but you will not use them in this lab.

   - Validation - This allows you to write an expression to confirm that input vaules are what you expect. You could set it to only allow a string that is between 3 and 6 characters long, perhaps only be a number between 1 and 6, or ensure that the input matches a regular expression. This is an advanced topic, and will not be covered by this session. If you wish to know more you can find information here
   - Sensitive - Should this value be hidden in the CLI? If so set the value to true
   - Nullable - Is "null" a valid value for your variable, basically is this variable allowed to be defined as empty.
 
9. Now you will create the tags variable. This variable will be of the "map" type, and have a default value.
    ```
    variable "tags" {
      type = map(string)
    }
    ```


10. Start by defining the variable, setting the type as a map of strings, and set a description for your variable.
    ```
    variable "tags" {
      type = map(string)
      description = "The tags to be added to resources"
    }
    ```
11. Finally set a default. As you start to type default you should get an autocomplete suggestion, click it (or press tab) to accept the suggestion you should get this.
    ```
    variable "tags" {
      type = map(string)
      description = "The tags to be added to resources"
      default = {
        "name" = "value"
      }
    }
    ```

12. Set the tags to be the following.
    ```
    variable "tags" {
      type = map(string)
      description = "The tags to be added to resources"
      default = {
        "service-name" = "training"
        "owner" = "your name"
      }
    }
    ```

Congratulations, you have now DEFINED two variables.
​
# Setting Variable Values
​
In the previous step you defined the two variables you are going to initially use, but you only set a default value for one of them. You need a way to set the value of the other variable, and this is done using a tfvars file.

1. Open the terraform.tfvars file
2. Type the following to set a value for the "vm_size" variable.
```
vm_size = "Standard_B2ms"
```

3. You do not NEED to set a value in tfvars for the tags variable because it has a **default**, but you **can** to override that default, and you will do this later in this lab.

4. Now you have defined a variable, and set the value, you now need to use the variables in your existing code.

# Using your variables
1. Open your main.tf file and locate the size property of the azurerm_windows_virtual_machine. Replace the existing value with your variable.
```
size = var.vm_size
```

2. You are also going to add your tags variable to your VM. Add the following line to your resource block.
```
tags = var.tags
```

3. Run a terraform apply. You should see that the size and tags are being applied with the variables. One is using the Default value set in the variable, while the other is using the value that has been set in the tfvars file.
 
4. Next you will override the default value of the tags variable. Open the terraform.tfvars file and add a value for the tags variable.
    ```
    tags = {
        service-name = "training"
        owner = "your name"
        extra-tag = "foo"
        }
    ```
 
5. Run another `terraform apply`.
 
6. Via the Portal confirm that the tags on the VM have been updated to what is in the tfvars file, and has the extra-tag value.

# What are locals?
Now you have created some variables, its time to look at Locals. Locals are used in a few ways, but the main two are:

Statically defining a repeated value that is not exposed to end users. So something that is used in multiple places, but you would not want a user to modify.
Processing or combining variables to make more complex values
You are going to use a local to combine two maps. To combine two maps you can use the merge function.

Functions are for data manipulation within Terraform. Terraform has various functions that you can use to manipulate text, lists, maps, numbers, dates, or even ip addresses. These will not be covered in depth in this session, but details on what they are and how to use them can be found here: Functions - Configuration Language | Terraform | HashiCorp Developer

# Using locals
​
1. At the top of your main.tf file create a locals block
    ```
    locals {
      
    }
    ```

2. Create a tags local, this will combine your existing tags variable, with a new key/value pair. 
    ```
    locals {
      tags = merge({new-tag = "stuff"}, var.tags)
    }
    ```

3. Update the main.tf tags references from var.tags to be local.tags (Find and Replace is your friend).
    ```
    resource "azurerm_windows_virtual_machine" "this" {
        ...
        tags = local.tags
        ...
    }
    ```

4. Run a terraform apply.
 
5. You should see that the apply wants to update the tags to include new-tag = "stuff", as well as what you have defined as the tags variable in tfvars.
​
# Looping Concepts
​
In Terraform, there are two ways to create multiple resource.  Count and For_Each are used to create multiple instances of resources, but they serve different purposes and have different applications.

The count meta-argument is simpler and best used when you need a specific number of very similar resources. It's like saying, "I need 5 of this resource". You use count with an integer to specify how many instances you want. Each instance is usually identical, but sometimes with minor differences, usually just the name handled through count.index argument. However, a drawback is that removing or adding resources can be tricky, and targetted removal of resources isnt possible, potentially disrupting the remaining resources, this can include destroying them.

```
resource "azurerm_windows_virtual_machine" "this" {
    count = 4
    name = "mywinvm${count.index}"
    ...
}
```

As an example the above would result in 4 VM's being created called mywinvm0, mywinvm1, mywinvm2, and mywinvm3. Setting the count down to 3 would remove mywinvm3. However using this method there is no easy way to remove mywinvm1 without also removing 2, and 3 as well.

for_each on the other hand, is more flexible and is used when your resources have more distinct differences. It works well when you're dealing with a set or map variable input, where each element creates a unique resource. Think of it like saying, "For each of these unique items, create a resource with these settings." This method ties each resource to a unique name called a "key", making your configuration more manageable and changes more predictable. It's particularly useful when the number of resources isn’t known upfront or varies based on input data.

```
variable "vms" {
  type = map(string)
  description = "Map of VM's to be created"
  default = {
    vm1 = { name = "eachvm1", size = "Standard_B2ms" }
    vm2 = { name = "eachvm2", size = "Standard_B2m" }
    vm3 = { name = "eachvm3", size = "Standard_B2ms" }
    vm4 = { name = "eachvm4", size = "Standard_B2ms" }
  }
}

resource "azurerm_windows_virtual_machine" "this" {
    for_each = var.vms
    name = each.value.name
    size = each.value.size
    ...
}
```

In the above example there are 4 vm's jsut like the count example, however if we want to delete vm2, you can, jsut be removing that line and only that one resource would be impacted.

Count was the initial looping meta-argument that was added to Terraform, for_each was added later. As a general rule, using for_each is the prefered way to create multiple resources, and recommended by Hashicorp, with count mainly being used to create "conditional" resources, where the resource is either there or it isnt, with a count of 0, or 1.

# Creating Multiple Virtual Machines (Count)
​
1. Open main.tf
2. Copy and paste your current azurerm_windows_virtual_machine resource block and update the reference name from "this" to "web". Ensure you copy the whole block, from "resource" to the closing "}"
   
    ```
    resource "azurerm_windows_virtual_machine" "this" {
        name = "mywinvm"
        ...
    }

    resource "azurerm_windows_virtual_machine" "web" {
        name = "mywinvm"
        ...
    }
    ```
 

3. Update the VM block to add the count propertyand  set the value to 3. Also update the name property to add the ${count.index} at the end. Note that when you want to use JUST a variable, or argument as a value you would just use that value e.g. name = count.index
   
    However when you want to use a variable or argument as part of a string, you need to use the ${} syntax. Additional details on what you can do with strings can be found here
    ```    
    resource "azurerm_windows_virtual_machine" "web" {
        count = 3
        name = "mywinvm${count.index}"
        ...
    }
    ``` 

4. Run a terraform apply.
   
   You will see that an error is thrown. This is because you have 3 VM's...but only one NIC. VM's arent big on sharing.
 
5. Much like you did with the VM code, copy and paste your network interface card resource and update its reference name to be "count". 
Add the count property to the network interface resource, and set the value to 3, the same as the VM. Also update the name so that each NIC will have a unique name.
    ```
    resource "azurerm_network_interface" "web" {
        count = 3
        name = "mywinvm${count.index}-nic"
        ...
    }
    ```

6. This means you will have 3 interfaces, with names mywinvm0-nic, mywinvm1-nic, and mywinvm2-nic. The terraform references to those interfaces will be azurerm_network_interface.this[0], azurerm_network_interface.this[2], and azurerm_network_interface.this[0].

7. Now you need to update your VM resource to use the right network interface card. Modify the network interface id property on your Web VM resource as below 
    ```
    network_interface_ids = [
        azurerm_network_interface.web[count.index].id,
      ]
    ```

    You are using the count index to look for the corresponding interface card. So vm 1 will use nic 1, vm 2 will use nic 2
 
8. Run a `terraform apply`
   This should create 3 VM's, with 0, 1, and 2 at the end of their names respectively.
   
In this section you set the same value in two different places. You set the count property to 3 for both the VM and NIC count. Given what you have been shown so far in this workshop, what would be a better way to do that?
​
# Creating Conditional Resources (Count)
In the previous step you used Count to create mutliple resources. Since Count has largely been superceded by For_Each, you will now learn the primary use case for count as suggested by Hashicorp, creating conditional resources.

1. Open your variables.tf file and create a new variable called "enable_storage_account".
   Set this variable to be a boolean (meaning true or false)
    ```
    variable "enable_storage_account" {
      type = bool
      description = "should a storage account be created"
      default = false
    }
    ```
2. Next you will define the storage account to  create
    ```
    resource "azurerm_storage_account" "this" {
      name                     = "storageaccountname"
      resource_group_name      = data.azurerm_resource_group.this.name
      location                 = data.azurerm_resource_group.this.location
      account_tier             = "Standard"
      account_replication_type = "LRS"
      tags = local.tags
    }
    ```
    The above will create the storage account not matter what, you need to update it to create only if enable_storage_account is true
3. Add the count property, and set the value to be as below
    ```   
    resource "azurerm_storage_account" "this" {
      count                    = var.enable_storage_account ? 1 : 0
      name                     = "storageaccountname"
      resource_group_name      = data.azurerm_resource_group.this.name
      location                 = data.azurerm_resource_group.this.location
      account_tier             = "Standard"
      account_replication_type = "LRS"
      tags = local.tags
    }
    ```
4. Let break down what is happening now. 
   
   You have set a condition, saying that that if the condition on the left of the ? is true set the count to 1, if the condition is false the count will be set to 0.
 
    Conditional expressions have the following format, can be alot more complex, and have many use cases but the basics are:
    condition ? true_val : false_val

5. Now run a terraform apply
 
6. Nothing should happen, because you have set the default value for enable_storage_account to be false, so the condition evaluates to 0.
 
7. Next update your tfvars file to set the value to be true
    ```   
    enable_storage_account = true
    ```
8. Rerun a terraform apply. You will see that this time the storage account is created.

# Creating Multiple Virtual Machines (For_Each)
​
In the previous step you created 3 VM's using count. You are now going to create some VM's using the for_each meta argument.

1. Open your variables.tf file, and create a new variable with the following properties.
- Name: vms
- Type: map
- Do not set a default
 
2. Set the value for the new variable in the tfvars file
    ```
    vms = {
        vm1 = { name = "vmwin01", size = "Standard_B2ms" }
        vm2 = { name = "vmwin02", size = "Standard_B2ms" }
    }
    ```
    This is a map of objects. Each line is an object with two settings, a name and a size. For this session we will only use these two settings, but this kind of variable can be as simple or as complex as required. It may only have 2 settings, it could have 20. When writing your own code rememeber that  the easier you make your inputs, the easier the code is to modify in future.

3. Create a new virtual machine resource using a for_each loop. As you did with the count VM example, copy and paste the azurerm_azure_virtual_machine block and update the reference name to be "app". Remember that the reference name can be whatever you like, its for reference within your code, but do try and keep it sensible.
 
4. Replace the count property with the for_each property and then tell it which variable you want to loop through which is var.vms
    ```
    resource "azurerm_windows_virtual_machine" "app" {
        for_each = var.vms
        ...
    }
    ```
5. Next you want to update the name of your VM to use the names you set in your variable, vmwin01, and vmwin02. To do this you use the each.value meta argument and tell it that the value to use is "name"
    ```
    resource "azurerm_windows_virtual_machine" "app" {
        for_each = var.vms
        name = each.value.name
        ...
    }
    ```
 

6. Finally repeat the same process but for the size property
    ```
    resource "azurerm_windows_virtual_machine" "app" {
        for_each = var.vms
        name = each.value.name
        size = each.value.size
        ...
    }
    ```
7. Now repeat the same process for the network interface card resource. Like you did in the count example, copy and paste the network interface code, update the reference name to  "each".
8. Replace the count property with for_each  and set the value to be var.vms
    ```
    resource "azurerm_network_interface" "app" {
        for_each = var.vms
        ...
    }
    ```
9. Set the name property to `each.value.name`. You should have something that looks like this
    ```
    resource "azurerm_network_interface" "app" {
        for_each = var.vms
        name = "${each.value.name}-nic"
        ...
    }
    ```
10. Finally you need to update your "each" vm resource to use your "each" network interfaces.
    ```
    resource "azurerm_windows_virtual_machine" "app" {
      for_each              = var.vms
      name                  = each.value.name
      ...
      network_interface_ids = [
        azurerm_network_interface.app[each.key].id,
      ]
      ...
    }
    ```
    Note that the way that the resource is referenced is different. When creating with a count, you use count.index, when creating with a for_each you use each.key.
 
11. Run a `terraform apply`
 
12. Now go back to the tfvars files, and create 5 VM's that are all different sizes, and update the names to be...whatever you like (they must be less than 15 characters). The allowed sizes are:
    - Basic_A0
    - Basic_A1
    - Standard_A1
    - Standard_A1_v2
    - Standard_A2
    - Standard_A2_v2
    - Standard_B1ms
    - Standard_B2ms
    - Standard_B4ms
    - 
13. Run a terraform apply, after the apply completes, you should have 5 new virtual machines, all of different sizes, with your new names.
 
14. Finally you will destroy your deployment. Type "terraform destroy" into the terminal, and confirm that your resources have been destroyed in the portal.
​
# Summary
Congratualtions you have now made use of variables, locals and created resources using the count and for_each meta arguments.

- You created two variables, setting a default for one of them
- You used the tfvars file to set a value for one variable, and override the default of the other
- You used the merge function to combine a static value, with your tags variable to create the tags local
- You used count to create 3 VM's and their corresponding NICs
- You used for_each to create 5 VM's and thir corresponding NICs