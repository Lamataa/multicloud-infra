# ── Public IP do Load Balancer ────────────────────────────────
resource "azurerm_public_ip" "lb" {
  name                = "InfraAZURE-lb-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["2", "3"]
}

# ── Load Balancer ─────────────────────────────────────────────
resource "azurerm_lb" "main" {
  name                = "InfraAZURE-lb"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

# ── Backend Pool ──────────────────────────────────────────────
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "InfraAZURE-backend-pool"
}

# ── Health Probe ──────────────────────────────────────────────
resource "azurerm_lb_probe" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# ── Load Balancing Rule ───────────────────────────────────────
resource "azurerm_lb_rule" "main" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
  load_distribution              = "SourceIPProtocol"
  disable_outbound_snat          = false
}

# ── Virtual Machine Scale Set ─────────────────────────────────
resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                = "InfraAZURE-vmss"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.vm_size
  instances           = 2
  admin_username      = var.admin_username
  zones               = ["2", "3"]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "InfraAZURE-vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
    }
  }

  custom_data = filebase64("${path.module}/cloud_init.sh")
}
