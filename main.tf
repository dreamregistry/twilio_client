terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {}
provider "random" {}

variable "twilio_api_key_sid" {}
variable "twilio_api_key_secret" { sensitive = true }
variable "twilio_phone_number" {}
variable "twilio_account_sid" {}

variable "twilio_auth_token" { sensitive = true }
variable "twilio_webhook_root_url" {
  type = string
  description = "The root URL to send Twilio webhooks to"
}

data "aws_region" "current" {
}

resource "random_pet" "pkg_id" {
  length = 2
}

resource "aws_ssm_parameter" "api_key_secret" {
  name  = "/twilio_client/${random_pet.pkg_id.id}/api_key_secret"
  type  = "SecureString"
  value = var.twilio_api_key_secret
}

resource "aws_ssm_parameter" "auth_token" {
  name  = "/twilio_client/${random_pet.pkg_id.id}/auth_token"
  type  = "SecureString"
  value = var.twilio_auth_token
}

output "TWILIO_API_KEY_SID" {
  value = var.twilio_api_key_sid
}

output "TWILIO_API_KEY_SECRET" {
  value = {
    type   = "ssm"
    key    = aws_ssm_parameter.api_key_secret.name
    region = data.aws_region.current.name
    arn    = aws_ssm_parameter.api_key_secret.arn
  }
}

output "TWILIO_AUTH_TOKEN" {
  value = {
    type   = "ssm"
    key    = aws_ssm_parameter.auth_token.name
    region = data.aws_region.current.name
    arn    = aws_ssm_parameter.auth_token.arn
  }
}

output "TWILIO_PHONE_NUMBER" {
  value = var.twilio_phone_number
}

output "TWILIO_ACCOUNT_SID" {
  value = var.twilio_account_sid
}

output "TWILIO_WEBHOOK_ROOT_URL" {
  value = var.twilio_webhook_root_url
}


