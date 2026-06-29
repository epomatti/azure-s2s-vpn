resource "aws_route53_zone" "azure" {
  name = "azure.vpn"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "azure_server" {
  zone_id = aws_route53_zone.azure.zone_id
  name    = "server"
  type    = "A"
  ttl     = 300
  records = [var.azure_server_private_ip]
}
