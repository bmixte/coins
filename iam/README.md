# Objectives :
write a Terraform module that creates the following resources in IAM; ---

- A role, with no permissions, which can be assumed by users within the same account,
- A policy, allowing users / entities to assume the above role,
- A group, with the above policy attached,
- A user, belonging to the above group.

# References
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy