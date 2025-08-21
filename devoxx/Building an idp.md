Building an IDP

IDP enables self service for developers, but should be "where they live", it doesnt need to be GUI, click button driven, it can be CLI, GitOps, or API driven, thats what Dev's use, its how they think, so why give them a GUI?

https://github.com/sebastienblanc/idp-workshop

Empowering Developers

Book: Platform Strategy - Gregor Hohpe

Direct Access to Kubernetes? No, use pipeline or GitOps.

Argo CD lives inside K8s, but in DLA we're looking at Flux as the enabler, bonus of flux is its in GitLab

Need to investigate Flux for Terraform deployments and move towards GitOps

## Operators

Custom Resource Definition in K8s that helps simplify things

Controllers that looks for custom resources and then does what is required

Custom Operators act as your controllers and define required inputs etc to simplify deployments

"watch" command to show "booting" deployments

"kubectl get crd" see al custom resource definitions

Kratix.io to help compose operators instead of building them by hand

We will end up with multiple IDP

Portal like Backstage or Port to help encapsulate, but doesnt proclude gitops methodology