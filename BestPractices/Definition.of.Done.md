# Definition of Done
## Problem Statement

Without agreed DoD engineers, testers, project managers and product owners are left to their own interpretation of what is **Done**. This leads to potential conflicts between different parties working on the same backlog of user stories. Platform engineers may say that work is **Done** because it delivers the required functionality, while testers may disagree if UAT phase was skipped, or not properly executed; likewise, service owners may join the argument because documentation was not created or updated. Having something as **Half-Done** would lead to disagreements within the team, technical debt accumulation, or in the worst-case scenario may even impact the firm's revenue.

> Unfinished work generates more work, because it is repeatedly moved back into **WIP** phase.

The DoD should help modern engineering function in delivering value to their customers while maintaining a high quality of their work. Something cannot be treated as done based on the engineer's feedback alone. Think of all the tasks required to progress changes through different environments into production, such as UAT testing, service acceptance, QA sign-off, etc. 

Meeting DoD means the chance of rework and accumulation of technical debt is lowered. 

The following checklist describes what needs to be met before any work can be proclaimed as **Done**.

## Checklist

- The proposed solution or change must meet documented requirements.
  - Always think MVP (Minimum Viable Product). 
  - Never deliver functionality that wasn't required or requested. 
  - Don't make assumptions, always clarify requirements.
- Proposed changes do not compromise the firm's security stance.
  - Do not expose services publicly, unless required.
  - Pass SAST checks, or ensure approved exceptions are documented.
- Code has been peer-reviewed.
  - Make sure your peers have had a chance to review your work in advance.
- The cost element has been communicated to the product owner and IT finance.
  - Don't assume the cost of your solution has been pre-approved.
  - Use prediction tools wisely (Azure Pricing Calculator, InfraCost, etc)
- Documentation has been created or updated to reflect the latest changes.
  - Documentation must be concise - **nobody** likes to read long documents.
  - The code is very good documentation, make sure you provide meaningful comments.
- Solution (or changes) has been tested in a sandbox and/or dev environments (if applicable).
- Deployment and configuration have been done using DevOps principles - as code, automated, and repeatable.

We acknowledge that not every requirement from the list above applies to every single change, therefore we trust our engineers to use their judgment.

CCoE will be offering support through peer reviews and merge request approvals to ensure these guidelines are well understood and being followed. 