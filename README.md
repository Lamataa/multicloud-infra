# 🌐 Multi-Cloud Infrastructure

Provisionamento automatizado de infraestrutura **multi-cloud** (AWS + Azure) usando **Terraform** e **GitHub Actions**. O projeto demonstra como tratar infraestrutura como código — qualquer mudança passa pelo Git e pelo pipeline antes de ser aplicada, eliminando intervenção manual no console das clouds.

---

## 🎯 Objetivo

Provisionar infraestrutura equivalente em duas clouds simultaneamente, com alta disponibilidade, pipeline CI/CD completo e scanning de segurança automatizado — seguindo práticas usadas em ambientes de produção.

---

## 🛠️ Stack

| Tecnologia | Uso |
|---|---|
| **Terraform 1.10+** | Provisionamento IaC modular |
| **GitHub Actions** | CI/CD pipeline multi-cloud |
| **AWS** | ALB, ASG, EC2, VPC, Multi-AZ |
| **Azure** | Load Balancer, VMSS, VNet, Zones |
| **Trivy + Checkov** | Security scanning automatizado |

---

## 🏗️ Arquitetura
```
push na branch test
        │
        ├──► AWS job      → validate → plan → apply
        ├──► Azure job    → validate → plan → apply
        └──► Security job → trivy + checkov
<<<<<<< HEAD
```

**AWS** — Alta disponibilidade com ALB + Auto Scaling Group em 2 Availability Zones
```
internet → ALB → EC2 (us-east-1a)
               → EC2 (us-east-1b)
```

**Azure** — Alta disponibilidade com Load Balancer + VMSS em 2 Zones
```
internet → Load Balancer → VM (zone 1)
                         → VM (zone 2)
=======
>>>>>>> 1b91d3058667a9a9bd7dc89c6950801ed1c938c4
```

---

## 📁 Estrutura
```
multicloud-infra/
│
├── .github/
│   └── workflows/
│       └── multiprovider.yaml
│
├── terraform/
│   ├── aws/
│   │   ├── modules/
│   │   │   ├── compute/       # ALB, ASG, Security Groups
│   │   │   │   ├── cloud_init.sh
│   │   │   │   ├── outputs.tf
│   │   │   │   ├── vars.tf
│   │   │   │   └── vm.tf
│   │   │   └── rede/          # VPC, Subnets, IGW, Route Table
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
│       │   ├── compute/       # Load Balancer, VMSS
│       │   │   ├── cloud_init.sh
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vm.tf
│       │   ├── rede/          # VNet, Subnet, NSG
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vnet.tf
│       │   └── rg/            # Resource Group
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

O pipeline roda os jobs AWS e Azure **em paralelo**, independentes entre si. O security scan também roda em paralelo e reporta findings sem bloquear o deploy.

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
| ALB (AWS) | Application Load Balancer | ~$16 |
| EC2 x2 (AWS) | t3.micro | ~$16 |
| Load Balancer (Azure) | Standard | ~$18 |
| VMSS x2 (Azure) | Standard_B2s | ~$30 |
| **Total** | | **~$80/mês** |

> 💡 O projeto foi feito para rodar pontualmente — sobe, tira os prints e destrói.
> ```bash
> terraform destroy
> ```

---

## ✅ Best Practices

<<<<<<< HEAD
- **Arquitetura modular** — rede e compute separados, reutilizáveis
- **Alta disponibilidade** — Multi-AZ na AWS, Zones na Azure
- **Remote state** — S3 (AWS) e Azure Storage com locking
- **Security scanning** — Trivy + Checkov em todo push
- **Apply protegido** — só na branch `test`, nunca direto na `main`
- **GitOps** — nenhuma mudança manual no console, tudo via código
- **Secrets no CI** — nenhuma credencial no código
=======
- Arquitetura modular — rede e compute separados
- Remote state — S3 e Azure Storage
- Security scanning — Trivy + Checkov
- Apply protegido — só na branch `test`
- Secrets no CI — nenhuma credencial no código
>>>>>>> 1b91d3058667a9a9bd7dc89c6950801ed1c938c4
