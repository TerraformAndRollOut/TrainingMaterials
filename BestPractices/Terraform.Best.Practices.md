# Terraform Best Practices

> Revision 2024 Q1

The following best practices are based on Google's [Best practices for using Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform) document, which has been deliberately simplified to ensure that presented content is relevant to <COMPANY NAME>'s environment and maturity level.

Although we encourage everyone to read Google's document for a better understanding of Terraform's capabilities and industry best practices, it should not be treated as <COMPANY NAME>'s collection of guidelines and recommendations. CCoE will maintain a reduced list of best practices to ensure it is relevant to our environment. This document will grow over time as engineers acquire the required skills and become more confident with Terraform. 

**DISCLAIMER**

- The guidelines provided below ensure scalability and maintainability of Terraform code.

- Future updates to CI/CD templates will support adherence to best practices.

- CCoE bears no responsibility for code breakage or reduced functionality resulting from non-adherence to guidelines.

- While individuals may opt not to follow these practices, they must be prepared to address any issues arising from their code during CI/CD template changes.

- CCoE will not attempt to rectify non-compliant code or include it in acceptance testing during template changes.

- Responsibility for code integrity lies solely with parties deviating from the best practices.

# Table of Contents

- [Terraform Best Practices](#terraform-best-practices)
- [Table of Contents](#table-of-contents)
  - [Standard Structure](#standard-structure)
  - [Naming Convention](#naming-convention)
      - [ Recommended:](#-recommended)
      - [ Not Recommended:](#-not-recommended)
      - [ Recommended:](#-recommended-1)
      - [ Not Recommended:](#-not-recommended-1)
  - [Input Variables](#input-variables)
      - [ Recommended:](#-recommended-2)
      - [ Not Recommended:](#-not-recommended-2)
      - [ Recommended:](#-recommended-3)
      - [ Not Recommended:](#-not-recommended-3)
  - [Output Attributes](#output-attributes)
      - [ Recommended:](#-recommended-4)
      - [ Not Recommended:](#-not-recommended-4)
  - [Terraform Docs](#terraform-docs)
  - [Secrets](#secrets)
  - [Randomize Resource Names](#randomize-resource-names)
  - [Modules](#modules)
  - [Use count for conditional resources](#use-count-for-conditional-resources)
  - [Use for\_each for creating multiple resources](#use-for_each-for-creating-multiple-resources)
  - [Support for Atomic Deployments](#support-for-atomic-deployments)
  - [Avoid importing resources created via ClickOps](#avoid-importing-resources-created-via-clickops)
  - [Use External data carefully](#use-external-data-carefully)
  - [Favor YAML over JSON](#favor-yaml-over-json)
  - [Adhere to Standard Release Process](#adhere-to-standard-release-process)
  - [Ensure Adequate Supportability](#ensure-adequate-supportability)
  - [Avoid Excessive Nesting Depth](#avoid-excessive-nesting-depth)
  - [Use of Isolated Environment for Testing](#use-of-isolated-environment-for-testing)


## Standard Structure

- Start every Terraform project with at least the following structure:

  ```bash
  env/
    preprod/               # Preprod env config:
      .tfvars              # Terraform variables' values
    prod/                  # Prod env config (files not shown)
    test/                  # Test env config (files not shown)
  terraform/               # Terraform code
    backend.tf             # Configuration of the backend and providers
    main.tf                # Main IaC resources
    outputs.tf             # Exposed output attributes (optional)
    variables.tf           # Definition of Terraform variables

  .gitignore               # List of files and dirs not tracked by Git
  .gitlab-ci.yml           # CI/CD configuration
  CODEOWNERS               # Defines project's approvers
  README.md                # Contains project's manual
  secrets.yml              # Metadata describing what secrets to retrieve from SMS
  ```

- With the natural growth of the `main.tf` file, consider moving logically grouped resources into their own files, such as
  - `network.tf`: virtual networks, subnets, routing tables.
  - `database.tf`: Database resources.
  - etc

- As a rule of thumb, **always** initialize your project from the standard template produced and maintained by the CCoE team as this will help you adhere to many best practices automatically, including enforcement of the CI/CD pipeline.

## Naming Convention

- Name all configuration objects using underscores to delimit multiple words. This practice ensures consistency with the naming convention for resource types, data source types, and other predefined values.

  #### ![Do](../media/thumbu.svg) Recommended:
  <pre>resource "azurerm_linux_virtual_machine" "<b>frontend_web_server</b>" { ... }</pre>

  #### ![Don't](../media/thumbd.svg) Not Recommended:
  <pre>resource "azurerm_linux_virtual_machine" "<b>frontend-web-server</b>" { ... }</pre>

- To simplify references to a resource that is the only one of its type (for example, a single subnet for an entire module), name the resource `this`, e.g. `azurerm.subnet.this`. Use a similar approach if resource entry represents a collection of resources using `for_each` or `count`.
    <pre>resource "azurerm_subnet" "<b>this</b>" { ... }</pre>

- To differentiate resources of the same type from each other (e.g. `primary` and `secondary`), provide meaningful resource names.

- Make resource names **singular**

- In the resource name, don't repeat the resource type.
  #### ![Do](../media/thumbu.svg) Recommended:
  <pre>resource "azurerm_linux_virtual_machine" "<b>primary</b>" { ... }</pre>

  #### ![Don't](../media/thumbd.svg) Not Recommended:
  <pre>resource "azurerm_linux_virtual_machine" "<b>primary_virtual_machine</b>" { ... }</pre>

## Input Variables

- Declare all variables in `variables.tf` file.

- Give variables descriptive names that are relevant to their usage or purpose.
    - Inputs, local variables, and outputs representing numeric values -such as disk sizes, or RAM size- **must** be named with units (like `ram_size_gb`).
    - To simplify conditional logic, give boolean variables positive names (e.g. `enable_public_access`).

- All variables **must** have meaningful descriptions.

- All variables **must** specify `type`:
  #### ![Do](../media/thumbu.svg) Recommended:
  <pre>variable "resource_group_name" {
    description = "The name of the resource group where solution will be deployed"
    type        = string
  }</pre>

  #### ![Don't](../media/thumbd.svg) Not Recommended:
  <pre>variable "resource_group_name" {}</pre>    

- When appropriate, provide default values
  - For variables that have environment-independent values, provide default values.
  - For variables that have environment-specific values, don't provide default values. Let CI/CD pipeline seed those values from the relevant `.tfvars` file.

- Document input variables in the `README.md` file, including variable names, types, default values and descriptions. Use [terraform-docs](#terraform-docs) to generate documentation.

- Only expose variables if these are expected to be changed by the user, don't use variables to reuse certain values in multiple places. In such cases consider using `locals` to define a re-usable label value without exposing a variable.

- Do not use the direct assignment of values within resource blocks, use variables or locals to provide values:
  #### ![Do](../media/thumbu.svg) Recommended:
  <pre>resource "azurerm_subnet" "this" {
    name             = <b>local.subnet_name</b>
    address_prefixes = <b>var.subnet_prefixes</b>
  }</pre>

  #### ![Don't](../media/thumbd.svg) Not Recommended:
  <pre>resource "azurerm_subnet" "this" {
    name             = <b>"SQLManagedInstance"</b>
    address_prefixes = <b>["10.176.17.0/25"]</b>
  }</pre>


## Output Attributes

- Organize all outputs in `outputs.tf` file.

- Provide a meaningful description for all outputs.

- Document output attributes in the `README.md` file, including their names and descriptions. Use [terraform-docs](#terraform-docs) to generate documentation.

- Expose all outputs that have the potential for consumption elsewhere (e.g. different projects).

- **DON'T** pass outputs directly through input variables as this impacts the construction of the dependency graph by Terraform. Make sure outputs reference attributes from resources, rather than variables:
  #### ![Do](../media/thumbu.svg) Recommended:
  <pre>output "vm_name" {
    description = "Virtual machine name"
    value       = <b>azurerm_virtual_machine.this.name</b>
  }</pre>

  #### ![Don't](../media/thumbd.svg) Not Recommended:
  <pre>output "vm_name" {
    description = "Virtual machine name"
    value       = <b>var.virtual_machine_name</b>
  }</pre>

## Terraform Docs

- Update the `Readme.md` file as often as possible. Updates for additional modules, resources, variables or outputs can easily be added using the terraform-docs command.

  `terraform-docs markdown table --output-file ../README.md --output-mode inject terraform`

- This is especially important with modules as engineers need to understand what valid inputs can be used to call the module. 

## Secrets

- **NEVER** commit secrets

- Create passwords using Terraform's `random_password` resource:

  <pre>random_password "linux" {
    length = 16
  }
  
  resource "azurerm_linux_virtual_machine" "this" {
    ...
    admin_username                  = "adminuser"
    <b>admin_password                  = random_password.linux.result</b>
    disable_password_authentication = false
    ...
  }
  
  resource "azurerm_key_vault_secret" "password" {
    name         = "adminuser"
    <b>value        = random_password.linux.result</b>
    key_vault_id = azurerm_key_vault.this.id
    ...
  }</pre>

- This resource generates a random password, which then can be stored in a Key Vault. In this way, passwords are only exposed via the Terraform state.

- Whenever possible use **private keys** for authentication. Key Vault can generate private/public key pairs without exposing private keys (`azurerm_key_vault_key`).

- When static secrets have to be injected into Terraform through one of the input variables, store these variables in Secrets Management Solution (currently HCP Vault). Speak to the CCoE team to get assistance.

- Should you end up feeding sensitive variables into your Terraform code, make sure to set a `sensitive` property to `true`:
  <pre>variable "admin_password" {
    description = "Local admin password"
    type        = string
    <b>sensitive   = true</b>
  }</pre>

- In the near future, we might be able to offer better secrets management when it comes to CI and IaC workflows.

## Randomize Resource Names

- To avoid naming conflicts make sure that your configuration generates non-overlapping names for all resources. This improves the re-usability of the code across deployments (subscriptions or regions).

- Randomly generated names help to ensure the pipeline finishes successfully.

- Random ID should be an optional naming component, made of 4 lower case alphanumeric characters:
  <pre>resource "random_string" "this" {
    count   = var.use_random_id ? 1 : 0 ### Makes it optional
    length  = 4
    special = false
    upper   = false
  }</pre>

## Modules

- Use [modules](https://artifacts.repo.com/ui/repos/tree/General/tf-modules-local/) whenever possible as these enforce standard configuration and best practices. Do not reinvent the wheel.

- Re-usable Terraform modules should not be used in production unless released into our Private Terraform Registry ([JFrog Artifactory](https://artifacts.repo.com/ui/)).

- By consuming modules from JFrog Artifactory we're decoupling module's released state from code's repository, enabling us to support potential restructures of GitLab repositories without impacting deployments relying on such modules.

## Use count for conditional resources

- To create a conditional resources use the `count` meta-argument

- This method can be used with data sources, resources, and modules

  <pre>variable "enable_app_server" {
     type = bool
     description = "Should the App server be deployed"
     default = false
  }
    
  resource "azurerm_windows_virtual_machine" "this" {
    # Do not create this resource unless the value is set to true.
    count = var.enable_app_server ? 1 : 0
    ...
  }</pre>

## Use for_each for creating multiple resources

- If you want to create multiple copies of a resource use the `for_each` meta-argument

- Your input variable will need to be a set, a map of strings, or a map of objects

- This method can be used with data sources, resources, and modules

  <pre>variable "machines" {
    type = map(object({
      name = string
      sku = string
    }))
  }
  
  machines = {
    vm1 = { name = "myvm1", sku = "Standard_B2s" }
    vm2 = { name = "myvm2", sku = "Standard_B2ms" }
    vm3 = { name = "myvm3", sku = "Standard_D2s" }
  }
  
  resource "azurerm_windows_virtual_machine" "this" {
    for_each = var.machines
    
    name = each.value.name
    sku  = each.value.sku
    ...
  }</pre>

## Support for Atomic Deployments

- Ensure that every Terraform deployment can be executed in a single operation without reliance on the `-target` keyword.

- This practice guarantees that all changes are transparent and visible during the review process, facilitating effective Merge Request approvals.

- Atomic operations uphold the integrity of infrastructure state by preventing partial changes, thus minimizing the risk of inconsistencies and deployment errors.

- Deployments relying on multiple cycles of `plan/apply` using the `-target` keyword are incompatible with Merge Requests, as they undermine the streamlined review process.

## Avoid importing resources created via ClickOps

- When infrastructure is initially created manually for testing purposes, treat it as temporary and refrain from attempting to import it into Terraform code. 
  
- Instead, produce Terraform code to recreate the infrastructure, adhering to Infrastructure as Code (IaC) principles.

- If unavoidable, then always prefer importing resources via [Terraform's `import` block](https://developer.hashicorp.com/terraform/language/import) over CLI's `terraform import` command.

- This approach is fully compatible with Merge Requests, offers visibility into state manipulation and does not require engineers to have access to the Terraform state outside of CI workflow.

- Treat importing of resources as a last resort option due to the potential for state inconsistencies.

- If new to state manipulation operations (`import`), seek assistance from the Cloud Center of Excellence (CCoE).

- Terraform state `import` is deemed to be acceptable in the following scenarios:
  - Merging two or more IaC repositories.
  - Migrating resources from one IaC repository to another.

## Use External data carefully

- Should Terraform code rely on any external data sources, such as external provider coupled with more complex logic hidden in the underlying scripts, then such sources/scripts must always produce predictable and consistent output providing the same input given.

- This helps to avoid unnecessary redeployments or changes that could impact infrastructure reliability and stability.

## Favor YAML over JSON

- Should Terraform code consume input data/variables from external files other than standard Terraform variables injected by a pipeline (`.tfvars`), then preference should be given to **YAML** format due to its superior readability over **JSON**.

- **YAML**'s simplified syntax ensures it is less error prone compared to **JSON**, its readability simplifies comprehension by non-engineering community, which is cruical in the established peer review and Merge Request approvals process.

Here's a sample **YAML** structure:

```yaml
this_is_list:
  - this_is_item_1
  - this_is_item_2
  - this_is_item_3
this_is_map:
  this_is_key_1: this_is_value_1
  this_is_key_2: this_is_value_2
  this_is_key_3: this_is_value_3
this_is_string: this_is_a_string
this_is_boolean: true
this_is_list_of_maps:
  - this_is_map_1_key_1: this_is_map_1_value_1
    this_is_map_1_key_2: this_is_map_1_value_2
  - this_is_map_2_key_1: this_is_map_2_value_1
    this_is_map_2_key_2: this_is_map_2_value_2
```

For comparison, here's a sample **JSON** structure:

```json
{
  "this_is_list": [
    "this_is_item_1",
    "this_is_item_2",
    "this_is_item_3"
  ],
  "this_is_map": {
    "this_is_key_1": "this_is_value_1",
    "this_is_key_2": "this_is_value_2",
    "this_is_key_3": "this_is_value_3"
  },
  "this_is_string": "this_is_a_string",
  "this_is_boolean": true,
  "this_is_list_of_maps": [
    {
      "this_is_map_1_key_1": "this_is_map_1_value_1",
      "this_is_map_1_key_2": "this_is_map_1_value_2"
    },
    {
      "this_is_map_2_key_1": "this_is_map_2_value_1",
      "this_is_map_2_key_2": "this_is_map_2_value_2"
    }
  ]
}
```

**JSON** becomes even more combersome when multiple nested structures are involved. It is also more error prone - you must only use double quotes, there should not be trailing comas in lists or maps, and it won't tolerate missing closing brackets. **YAML**, in turn, only cares about indentation levels.

## Adhere to Standard Release Process

- Provisioning of the IaC using Terraform code into production should be done inline with established CI processes, utilizing standard pipeline templates.

- By adhering to standard CI processes we ensure consistent testing and validation as we evolve with our DevOps journey.

## Ensure Adequate Supportability

- Terraform code, especially reusable modules, should be designed with supportability in mind.

- At least two engineers (excluding the author) should possess the necessary knowledge and capability to provide full support in the event of functionality degradation or breakage.

- This requirement ensures resilience and continuity of operations even in the absence of the original author.

## Avoid Excessive Nesting Depth

- Strive to keep the nesting depth of reusable Terraform modules to a maximum of 2 levels, as recommended by [HashiCorp](https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation#nesting-modules).

- Excessive nesting in Terraform complicates troubleshooting and maintenance, hindering scalability.

- While aiming for DRY code, it's crucial to prevent overly intricate structures.

- Recommended nesting depth of two levels ensures clarity and manageability.

## Use of Isolated Environment for Testing

- Smoke testing deployments should be conducted in an isolated environment, preferably a Sandbox subscription.

- Isolating dev/test deployments in a dedicated environment minimizes the risk of unintended consequences on production systems, facilitating safe testing practices.
