# 🌐 Multi-Cloud Infrastructure

Provisionamento automatizado de infraestrutura multi-cloud (AWS + Azure)
usando Terraform e GitHub Actions.

---

## 🛠️ Stack

| Tecnologia | Uso |
|---|---|
| **Terraform 1.10+** | Provisionamento IaC |
| **GitHub Actions** | CI/CD pipeline |
| **AWS** | EC2, VPC, Security Group |
| **Azure** | VM, VNet, NSG, Resource Group |
| **Trivy + Checkov** | Security scanning |

---

## 🏗️ Arquitetura
```
push na branch test
        │
        ├──► AWS job      → validate → plan → apply
        ├──► Azure job    → validate → plan → apply
        └──► Security job → trivy + checkov
```

---

## 📁 Estrutura
```
quickops-multicloud-cicd/
│
├── .github/
│   └── workflows/
│       └── multiprovider.yaml
│
├── terraform/
│   ├── aws/
│   │   ├── modules/
│   │   │   ├── compute/
│   │   │   │   ├── cloud_init.sh
│   │   │   │   ├── outputs.tf
│   │   │   │   ├── vars.tf
│   │   │   │   └── vm.tf
│   │   │   └── rede/
│   │   │       ├── outputs.tf
│   │   │       ├── vars.tf
│   │   │       └── vpc.tf
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   └── vars.tf
│   │
│   └── azure/
│       ├── modules/
│       │   ├── compute/
│       │   │   ├── cloud_init.sh
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vm.tf
│       │   ├── rede/
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vnet.tf
│       │   └── rg/
│       │       ├── rg.tf
│       │       └── vars.tf
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       └── vars.tf
│
├── .gitignore
├── LICENSE
└── README.md
```

---

## 🚀 Pipeline

| Branch | Validate | Plan | Apply |
|---|---|---|---|
| `main` | ✅ | ✅ | ❌ |
| `test` | ✅ | ✅ | ✅ |
| PR → `main` | ✅ | ✅ | ❌ |

---

## ⚙️ Secrets necessários

| Secret | Origem |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM User AWS |
| `AWS_SECRET_ACCESS_KEY` | IAM User AWS |
| `AZURE_CLIENT_ID` | Service Principal |
| `AZURE_CLIENT_SECRET` | Service Principal |
| `AZURE_SUBSCRIPTION_ID` | Azure CLI |
| `AZURE_TENANT_ID` | Service Principal |
| `SSH_PUBLIC_KEY` | `cat ~/.ssh/id_rsa.pub` |

---

## 🔧 Como rodar localmente
```bash
# AWS
cd terraform/aws
terraform init
terraform plan
terraform apply

# Azure
cd terraform/azure
terraform init
terraform plan -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

---

## 💰 Custo estimado

| Recurso | Tipo | Custo/mês |
|---|---|---|
| EC2 | t3.micro | ~$8 |
| VM Azure | Standard_B1s | ~$8 |
| **Total** | | **~$16/mês** |

> 💡 Destrua quando não estiver usando: `terraform destroy`

---

## ✅ Best Practices

- Arquitetura modular — rede e compute separados
- Remote state — S3 e Azure Storage
- Security scanning — Trivy + Checkov
- Apply protegido — só na branch `test`
- Secrets no CI — nenhuma credencial no código
