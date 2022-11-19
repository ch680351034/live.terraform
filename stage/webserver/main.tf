provider "aws" {
  region = "us-east-1"
}


##############backend
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-up-and-running-statech"
    key            = "stage/webserver/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}


module "webserver_cluster" {
  source = "../../modules/services/webserver-cluster"

  cluster_name = "stage-ws"
  instance_type = "t2.micro"
  min_size = 1
  max_size = 2
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}
