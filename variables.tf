variable "region" {
  default = "ap-northeast-1"
}

variable "codebuild_source_bucket_name" {
  default = ""
}

variable "codebuild_project_service_role_name" {
  default = ""
}

variable "codebuild_project_service_role_policy_name" {
  default = ""
}

variable "codebuild_project_name" {
  default = ""
}

variable "codebuild_project_description" {
  default = ""
}

variable "codebuild_project_artifacts_type" {
  default = "NO_ARTIFACTS"
}

variable "codebuild_project_cache_type" {
  default = "NO_CACHE"
}

variable "codebuild_project_compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_project_image" {
  default = ""
}

variable "codebuild_project_type" {
  default = "LINUX_CONTAINER"
}

variable "codebuild_project_privileged_mode" {
  default = ""
}

variable "docker_image_repo_name" {
  default = ""
}

variable "docker_image_repo_tag" {
  default = ""
}
