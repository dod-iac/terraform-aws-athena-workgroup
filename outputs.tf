output "arn" {
  description = "The Amazon Resource Name (ARN) of the workgroup."
  value       = aws_athena_workgroup.main.arn
}

output "id" {
  description = "The id of the workgroup."
  value       = aws_athena_workgroup.main.id
}
