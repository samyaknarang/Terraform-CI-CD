resource "aws_s3_bucket" "project_bucket" {

  #checkov:skip=CKV_AWS_144:Cross-region replication is deferred for this learning bucket
  #checkov:skip=CKV_AWS_18:Access logging will be added with a dedicated logging bucket
  #checkov:skip=CKV2_AWS_62:Event notifications are deferred until an event-driven use case is implemented

  bucket_prefix = "terraform-cicd-"

  tags = {
    name       = "terraform CI-CD"
    Enviorment = "learning"
    Managedby  = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "project_bucket" {
  bucket                  = aws_s3_bucket.project_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_versioning" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id

  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}