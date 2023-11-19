# Linode VPS infra

## Usage

First get tokens from GoDaddy.com and Linode (PAT with enough access scope), insert in SECRET file:

```sh
# File: ../secrets/SECRET
#!/usr/bin/env bash

export GODADDY_API_KEY=api key
export GODADDY_API_SECRET=api secret
export LINODE_TOKEN=personal access token
```

Then load environment and apply:

```sh
source ../secrets/SECRET
terraform apply
```

