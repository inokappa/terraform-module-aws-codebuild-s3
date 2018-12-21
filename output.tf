output "codebuild_s3_codebuild_project_arn" {
  description = "The ARN of the CodeBuild Project"
  value       = "${element(concat(aws_codebuild_project.codebuild_s3.*.arn, list("")), 0)}" 
}
