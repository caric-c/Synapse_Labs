//ticket 01//

resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.bucket_name


    tags = {
        Name        = var.bucket_name
        Environment = var.environment
    }
}
    

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
    bucket = aws_s3_bucket.s3_bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
    bucket = aws_s3_bucket.s3_bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

