# Lesson Guide for CCoE

## Session 1
After each resource is added do a terraform apply. Do not wait to the end of the coding to then try and debug.

Timings should be roughly 5 minutes for everyone to arrive, 80 minutes for the coding, 30 minutes for the State, Module, and Best Practice discussions, then 5 minutes at the end for questions.

1. Clone repo, and discuss the basic file layout (main, variables, backend, etc). Say that for this session we wont use the tfvars, variables, or output file, those are for session 2.
2. Add provider configuration. Asking what is a provider? Show the provider list on Terraform.io.
3. Discuss azure backend state but say why we aren't using it for this workshop (because later on we want to be able to easily read it).
4. Create a Resource Group (use the Terraform.io example, but updated to "this" and "rg-tfworkshop-name", do not set any tags initially). Make sure to be using "this" as the reference name.
5. Do an init and a plan, see that it shows 1 to create.
6. Do an apply, discuss the policy error that shows.
7. Discuss that a successful plan does not automatically mean a successful apply.
8. Update the RG with the servicename and team tags, and redo the apply.
9. Using Terraform.io guide them through creating the vnet, no need for the subnet settings, but use the cidr settings in this projects readme.md.
10. Now have them apply the principal on their own to create the subnet, again using the subnet cidr in the readme.md, but ignore the delegation settings.
11. Next up create the VM and NIC, use the terraform.io example. Tell them they need to update 5 or 6 things in the example to get it working...let them figure out what that is.
12. Get them to plan, but not apply for the VM.
13. Ask what is wrong with the VM code (correct answer = plain text password).
14. Add a random_password resource and add that to the vm.
15. Get them to do an apply and then discuss why they get the error, then need to do an init again because they have added a new provider (random).
16. Redo an init, and an apply, they should now have a VM, OS disk, vnet, subnet and resource group.
17. With the resources deployed, show them the state file for awareness, and give the "here there be dragons" speech about not modifying it directly.
18. Talk though how Terraform uses the state file to know what it has built and what has changed.
19. Show a "terraform state list".
20. Discuss the DLA modules locations, Artifacts for published, Gitlab for the code.
21. Discuss the DLA Terraform Best Practices.
22. TERRAFORM DESTROY
23. End with questions.

## Key Messages
- Everyone will learn this at a different rate, so long as they are progressing, forward momentum is what is important.
- Don't try and do anything complicated to start with. Start simple and add complexity
- The most important thing to begin with is does it build what you want. We can work on making it more efficient, more DRY, and prettier as their skill level develops