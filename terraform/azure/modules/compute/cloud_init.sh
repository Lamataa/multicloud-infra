#!/bin/bash
set -euo pipefail
exec > /var/log/cloud_init.log 2>&1

echo ">>> Starting bootstrap at $(date)"

# Atualizar sistema e instalar nginx
apt-get update -y
apt-get install -y nginx curl

# Habilitar e iniciar nginx
systemctl enable nginx
systemctl start nginx

# Coletar metadados da VM
VM_NAME=$(curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/instance?api-version=2021-02-01" \
  | grep -o '"name":"[^"]*"' | head -1 | cut -d'"' -f4)

VM_SIZE=$(curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/instance?api-version=2021-02-01" \
  | grep -o '"vmSize":"[^"]*"' | head -1 | cut -d'"' -f4)

LOCATION=$(curl -s -H "Metadata: true" \
  "http://169.254.169.254/metadata/instance?api-version=2021-02-01" \
  | grep -o '"location":"[^"]*"' | head -1 | cut -d'"' -f4)

PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

# Criar página web
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Azure Infrastructure</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', sans-serif;
      background: #0d1117;
      color: #e6edf3;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
    .card {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 12px;
      padding: 2.5rem;
      max-width: 600px;
      width: 100%;
    }
    .badge {
      display: inline-block;
      background: #0078d4;
      color: #fff;
      font-weight: 700;
      font-size: 0.85rem;
      padding: 4px 14px;
      border-radius: 20px;
      margin-bottom: 1.5rem;
    }
    h1 { font-size: 1.8rem; margin-bottom: 0.4rem; }
    .subtitle { color: #8b949e; margin-bottom: 2rem; font-size: 0.95rem; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
    .stat {
      background: #0d1117;
      border: 1px solid #30363d;
      border-radius: 8px;
      padding: 1rem;
    }
    .stat-label {
      color: #8b949e;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 4px;
    }
    .stat-value { color: #58a6ff; font-weight: 600; }
    .status {
      margin-top: 1.5rem;
      padding: 0.75rem 1rem;
      background: #0d1117;
      border: 1px solid #238636;
      border-radius: 8px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .dot {
      width: 10px; height: 10px;
      background: #2ea043;
      border-radius: 50%;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.4; }
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">☁️ Microsoft Azure</div>
    <h1>Azure Infrastructure</h1>
    <p class="subtitle">Multi-Cloud · Terraform · GitHub Actions</p>
    <div class="grid">
      <div class="stat">
        <div class="stat-label">VM Name</div>
        <div class="stat-value">$VM_NAME</div>
      </div>
      <div class="stat">
        <div class="stat-label">VM Size</div>
        <div class="stat-value">$VM_SIZE</div>
      </div>
      <div class="stat">
        <div class="stat-label">Location</div>
        <div class="stat-value">$LOCATION</div>
      </div>
      <div class="stat">
        <div class="stat-label">Public IP</div>
        <div class="stat-value">$PUBLIC_IP</div>
      </div>
    </div>
    <div class="status">
      <div class="dot"></div>
      <span>Online · Provisioned by Terraform</span>
    </div>
  </div>
</body>
</html>
EOF

echo ">>> Bootstrap complete at $(date)"