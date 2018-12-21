# terraform-module-aws-codebuild-s3 [![CircleCI](https://circleci.com/gh/inokappa/terraform-module-aws-codebuild-s3.svg?style=svg)](https://circleci.com/gh/inokappa/terraform-module-aws-codebuild-s3)

## About

* Terraform Module for CodeBuild + S3

## Usage

```hcl
module "codebuild-s3-docker-image-build" {
  source                                     = "git::https://github.com/inokappa/terraform-module-aws-codebuild-s3.git"
  codebuild_source_bucket_name               = "codebuild-docker-build-project-sources"
  codebuild_project_service_role_name        = "codebuild-docker-build-project-service-role"
  codebuild_project_service_role_policy_name = "codebuild-docker-build-project-policy"
  codebuild_project_name                     = "codebuild-docker-build-project"
  codebuild_project_description              = "Build Project for Docker Container Image"
  codebuild_project_image                    = "aws/codebuild/docker:18.09.0"
  codebuild_project_privileged_mode          = true
  docker_image_repo_name                     = "codebuild-docker-build-project-image"
  docker_image_repo_tag                      = "latest"
}
```
