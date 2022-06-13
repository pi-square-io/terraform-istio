
variable "name" {
  description = "Release name"
  type        = string
}

variable "repository" {
  description = "Repository URL where to locate the requested chart"
  type        = string
  default     = null
}

variable "chart" {
  description = "Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if repository is specified"
  type        = string
}

variable "create_namespace" {
  description = "Create the namespace if it does not yet exist"
  type        = bool
  default     = false
}

variable "namespace" {
  description = "The namespace to install the release into"
  type        = string
  default     = "default"
}

variable "release_version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed."
  type        = string
  default     = null
}

variable "set" {
  description = "Value block with custom values to be merged with the values yaml"
  type        = list(map(string))
  default     = null
}