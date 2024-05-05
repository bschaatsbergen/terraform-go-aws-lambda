module "my_app_archive" {
  source      = "../"
  source_path = "${path.module}/my-app"
  output_path = "${path.module}/my-app/my-app.zip"
}
