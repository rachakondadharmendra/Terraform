output "cicd_build_role" {
  value = aws_iam_role.cicd_build_role
}

output "cicd_codepipeline_role" {
  value = aws_iam_role.cicd_codepipeline_role
}