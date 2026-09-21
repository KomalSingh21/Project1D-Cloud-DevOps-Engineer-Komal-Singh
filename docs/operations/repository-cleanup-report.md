# Repository Cleanup Report

## Cleanup checks

```bash
git status --short
git ls-files | sort
git grep -n -I -E 'AKIA[0-9A-Z]{16}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|password:|token:|api[_-]?key'
find . -type f \( -name '*.env' -o -name '*.tfstate' -o -name '*.pem' \) -not -path './.git/*'
```

Review every match manually. Documentation examples and placeholders must be clearly labeled and must not resemble usable credentials.

Remove temporary archives, local environment files, editor metadata, generated secret output, Terraform state, and unapproved internal endpoints. Keep required diagram sources and exported images.
