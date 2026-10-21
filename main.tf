resource "aws_s3_bucket" "project_bucket" {
  bucket_prefix = "terraform-cicd-"

  tags = {
    name       = "terraform CI-CD"
    Enviorment = "learning"
    Managedby  = "terraform"
  }
}