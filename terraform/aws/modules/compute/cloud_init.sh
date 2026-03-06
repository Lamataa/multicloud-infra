#!/bin/bash
exec > /var/log/cloud_init.log 2>&1

echo ">>> Starting bootstrap at $(date)"

# Atualizar sistema e instalar nginx
yum update -y
yum install -y nginx

# Habilitar e iniciar nginx
systemctl enable nginx
systemctl start nginx

# Aguardar nginx subir
sleep 5

# Coletar metadados da instância
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Criar página web
cat > /usr/share/nginx/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>AWS Infrastructure</title>
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
      background: #ff9900;
      color: #000;
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
    <div class="badge">☁️ Amazon Web Services</div>
    <h1>AWS Infrastructure</h1>
    <p class="subtitle">Multi-Cloud · Terraform · GitHub Actions</p>
    <div class="grid">
      <div class="stat">
        <div class="stat-label">Instance ID</div>
        <div class="stat-value">INSTANCE_ID_PLACEHOLDER</div>
      </div>
      <div class="stat">
        <div class="stat-label">Instance Type</div>
        <div class="stat-value">INSTANCE_TYPE_PLACEHOLDER</div>
      </div>
      <div class="stat">
        <div class="stat-label">Availability Zone</div>
        <div class="stat-value">AZ_PLACEHOLDER</div>
      </div>
      <div class="stat">
        <div class="stat-label">Public IP</div>
        <div class="stat-value">PUBLIC_IP_PLACEHOLDER</div>
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

# Substituir placeholders com valores reais
sed -i "s/INSTANCE_ID_PLACEHOLDER/$INSTANCE_ID/g" /usr/share/nginx/html/index.html
sed -i "s/INSTANCE_TYPE_PLACEHOLDER/$INSTANCE_TYPE/g" /usr/share/nginx/html/index.html
sed -i "s/AZ_PLACEHOLDER/$AZ/g" /usr/share/nginx/html/index.html
sed -i "s/PUBLIC_IP_PLACEHOLDER/$PUBLIC_IP/g" /usr/share/nginx/html/index.html

systemctl restart nginx
echo ">>> Bootstrap complete at $(date)"