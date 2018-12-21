data "aws_caller_identity" "self" {}

resource "aws_iam_role_policy" "codebuild_s3" {
  name = "${var.codebuild_project_service_role_policy_name}"
  role = "${aws_iam_role.codebuild_s3.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::${var.codebuild_source_bucket_name}",
                "arn:aws:s3:::${var.codebuild_source_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ],
            "Action": [
                "s3:ListBucket"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/*",
                "arn:aws:logs:${var.region}:${data.aws_caller_identity.self.account_id}:log-group:/aws/codebuild/*:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-${var.region}-*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "codebuild_s3" {
  name = "${var.codebuild_project_service_role_name}"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "codebuild_s3" {
  bucket = "${var.codebuild_source_bucket_name}"
  acl    = "private"

  versioning = {
    enabled = true
  }
  force_destroy = true
}

resource "aws_codebuild_project" "codebuild_s3" {
  name         = "${var.codebuild_project_name}"
  description  = "${var.codebuild_project_description}"
  service_role = "${aws_iam_role.codebuild_s3.arn}"

  artifacts {
    type = "${var.codebuild_project_artifacts_type}"
  }

  cache {
    type = "${var.codebuild_project_cache_type}"
  }

  environment {
    compute_type    = "${var.codebuild_project_compute_type}"
    image           = "${var.codebuild_project_image}"
    type            = "${var.codebuild_project_type}"
    privileged_mode = "${var.codebuild_project_privileged_mode}"

    environment_variable {
      "name"  = "AWS_ACCOUNT_ID"
      "value" = "${data.aws_caller_identity.self.account_id}"
    }

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${var.region}"
    }

    environment_variable {
      "name"  = "IMAGE_REPO_NAME"
      "value" = "${var.docker_image_repo_name}"
    }

    environment_variable {
      "name"  = "IMAGE_TAG"
      "value" = "${var.docker_image_repo_tag}"
    }
  }

  source {
    type     = "S3"
    location = "${aws_s3_bucket.codebuild_s3.bucket}/source.zip"
  }
}

resource "aws_ecr_repository" "codebuild_s3" {
  name = "${var.docker_image_repo_name}"
}
