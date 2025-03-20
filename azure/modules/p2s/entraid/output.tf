output "p2s_desktop_user_object_id" {
  value = azuread_user.desktop_user.object_id
}

output "p2s_desktop_user_upn" {
  value = azuread_user.desktop_user.user_principal_name
}
