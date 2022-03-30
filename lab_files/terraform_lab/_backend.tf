terraform {
    backend "s3" {
        key = "finance/front-end-systems/terraform.tfstate"
        region = "<<REGION>>"
        bucket = "<<BUCKET NAME>>"
        dynamodb_table = "<<DYNAMODB TABLE>>"
        encrypt = true
    }
}
