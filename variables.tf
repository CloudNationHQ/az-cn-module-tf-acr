variable "registry" {
  type = any
}

variable "naming" {
  type    = map(string)
  default = {}
}

//variable "use_aliased_provider" {
//  description = "Flag to determine if aliased provider should be used"
//  type        = bool
//}
