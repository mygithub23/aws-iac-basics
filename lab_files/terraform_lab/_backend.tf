terraform {
  backend "s3" {
    key            = "finance/front-end-systems/terraform.tfstate"
    region         = "us-east-1"
    bucket         = "terraform-20221024"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
