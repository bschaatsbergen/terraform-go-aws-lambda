output "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the source code."
  value       = data.archive_file.zip.output_base64sha256
}

output "output_path" {
  description = "Path to the output archive."
  value       = data.external.build.result.output_path
}
