variable "source_path" {
  description = "Path to source code."
  type        = string
}

variable "output_path" {
  description = "Path to output archive."
  type        = string
}

variable "install_dependencies" {
  description = "Whether to install dependencies."
  type        = bool
  default     = true
}
