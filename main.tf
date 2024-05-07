data "external" "build" {
  program = ["bash", "${path.module}/build.sh"]
  query = {
    architecture         = var.architecture
    source_path          = var.source_path
    output_path          = var.output_path
    install_dependencies = var.install_dependencies
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = data.external.build.result.binary_path
  output_path = var.output_path
}
