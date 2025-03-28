variable "access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type           = string  
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "vpc" {
  source = "../modules/vpc"
}

module "ec2" {
  source = "../modules/ec2"
  vpc_id = module.vpc.vpc_id
  public_subnet1_id = module.vpc.public_subnet1_id
  public_subnet2_id = module.vpc.public_subnet2_id
}

module "alb" {
  source = "../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet1_id = module.vpc.public_subnet1_id
  public_subnet2_id = module.vpc.public_subnet2_id
  instance1_id = module.ec2.instance1_id
  instance2_id = module.ec2.instance2_id
}

module "rds" {
  source = "../modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet1_id = module.vpc.private_subnet1_id
  private_subnet2_id = module.vpc.private_subnet2_id
}

module "cloudfront" {
  source = "../modules/cloudfront"
  alb_dns = module.alb.alb_dns
}

module "route53" {
  source = "../modules/route53"
  cloudfront_dns = module.cloudfront.cloudfront_dns
}

terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"   
    key            = "terraform/state.tfstate" 
    region         = "hogehoge"          
    encrypt        = true                   
    dynamodb_table = "hogehoge" 
  }
}
