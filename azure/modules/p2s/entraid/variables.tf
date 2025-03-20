variable "p2s_entraid_tenant_domain" {
  type = string
}

variable "p2s_entraid_desktop_user_name" {
  type = string
}

variable "p2s_entraid_desktop_user_password" {
  type      = string
  sensitive = true
}
