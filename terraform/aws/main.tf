module "rede" {
  source        = "./modules/rede"
  rede_cidr     = var.rede_cidr
  subnet_cidr_a = var.subnet_cidr_a
  subnet_cidr_b = var.subnet_cidr_b
}

module "compute" {
  source     = "./modules/compute"
  rede_id    = module.rede.vpc_id
  subnet_ids = module.rede.subnet_ids
  rede_cidr  = var.rede_cidr
  ami        = var.ami
  depends_on = [module.rede]
}