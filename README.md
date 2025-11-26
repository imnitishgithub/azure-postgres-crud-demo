# Azure Postgres CRUD Demo

This repository provisions an Azure PostgreSQL Flexible Server in a VNet, deploys an Azure Function App (Python) with HTTP CRUD endpoints, and includes Logic App templates to call the functions.

**Important:** The user previously posted a GitHub Personal Access Token (PAT) publicly. **Revoke that token immediately** from GitHub Settings → Developer settings → Personal access tokens. Do **not** reuse that token. Never share PATs in chat.

## Repo structure

```
azure-postgres-crud-demo/
├── README.md
├── infra/
│   ├── deploy-postgres-vnet.ps1
│   ├── cleanup-resources.ps1
│   └── deploy-postgres-vnet.bicep
├── functionapp/
│   ├── requirements.txt
│   ├── local.settings.example.json
│   └── src/
│       ├── Create/__init__.py
│       ├── Read/__init__.py
│       ├── Update/__init__.py
│       ├── Delete/__init__.py
│       └── shared/pg_client.py
├── logicapp/
│   └── logicapp-workflow.json
└── scripts/
    └── test-crud.ps1
```

## Quick steps

1. Review and edit `infra/deploy-postgres-vnet.ps1` or the Bicep file to set names/passwords.
2. Login to Azure:
   ```powershell
   az login
   az account set -s "<subscription-id>"
   ```
3. Deploy infra (PowerShell):
   ```powershell
   cd infra
   ./deploy-postgres-vnet.ps1
   ```
4. Zip and deploy function app code to the Function App (the infra script can create the Function App and storage account).
5. Import the logic app JSON in Logic Apps designer and replace function URL and key.
6. Run `scripts/test-crud.ps1` to validate endpoints.

## Security
- Use Key Vault or Managed Identity in production for DB credentials.
- Revoke any exposed PAT immediately.

