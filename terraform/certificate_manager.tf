# hosted zone was created manually which is called in data source
data "aws_route53_zone" "smart-techthings" {
    name         = "${var.root_domain}."
}

# wild card certificate request
resource "aws_acm_certificate" "this" {
    domain_name       = "${var.sub_domain}.${var.root_domain}"
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

# create dns entry for certificate
resource "aws_route53_record" "web_cert_validation" {
    zone_id = data.aws_route53_zone.smart-techthings.zone_id
    name    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
    type    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
    records = [tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value]
    ttl = "60"
    allow_overwrite = true
}

# dns validation for certificate issueing
resource "aws_acm_certificate_validation" "this" {
    certificate_arn         = aws_acm_certificate.this.arn
    validation_record_fqdns = [aws_route53_record.web_cert_validation.fqdn]

    lifecycle {
        create_before_destroy = true
    } 
}

data "aws_acm_certificate" "this" {
    domain   = "${var.sub_domain}.${var.root_domain}"
    statuses = ["ISSUED"]
    depends_on = [ aws_acm_certificate_validation.this ]
}

# create cname entry for nodeapp.smart-techthings.com
resource "aws_route53_record" "this" {
    name = var.dns_record_name
    type = "CNAME"

    records = [ aws_lb.myapp_alb.dns_name ]
        

    zone_id = data.aws_route53_zone.smart-techthings.zone_id
    ttl     = "60"
}