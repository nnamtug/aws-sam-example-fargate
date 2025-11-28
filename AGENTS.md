# AGENT guidelines for this repo

- Scope: These instructions apply to the entire `aws-sam-example-fargate` repository.
- Keep changes minimal and focused on the user’s request; avoid refactoring unrelated templates, scripts, or resources.
- Preserve the existing AWS SAM and CloudFormation structure in `template.yaml`; add new resources rather than restructuring unless explicitly asked.
- For shell scripts in this repo, follow the existing style (Bash, simple flags, no large framework rewrites) and avoid introducing external dependencies beyond what the README lists.
- When adding infrastructure examples, favor least-privilege IAM and keep comments concise and practical.
- Prefer updating documentation in `README.md` when behavior, commands, or scripts change in a user-visible way.
