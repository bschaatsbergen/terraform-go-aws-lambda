output "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the source code."
  value       = data.external.builder.result.source_code_hash
}

output "output_path" {
  description = "Path to the output archive."
  value       = data.external.builder.result.output_path
}
