
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
  mfa_configuration          = "OFF"
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_uppercase = true
  }

  schema{
    name = "email"
    required = true
    attribute_data_type = "String"
    mutable = false
    string_attribute_constraints { 
      min_length = 1              
      max_length = 255            
    }
  }
  schema{
    name = "userType"
    required = false
    attribute_data_type = "String"
    mutable = false
    string_attribute_constraints { 
      min_length = 1              
      max_length = 255            
    }
  }
  
  auto_verified_attributes = ["email"]
  username_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Helping Hand Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }
}


resource "aws_cognito_user_pool_client" "user_pool_client" {
  name = var.user_pool_client_name

  user_pool_id = aws_cognito_user_pool.user_pool.id
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]
  generate_secret = true
  access_token_validity = 1
  refresh_token_validity = 30

}
