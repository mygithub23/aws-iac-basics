terraform {
    backend "s3" {
        key = "finance/front-end-systems/terraform.tfstate"
        region = "us-east-1"
        bucket = "tf-state-storage-202202"
        dynamodb_table = "for-terraform-state-lock"
        encrypt = true
    }
}
