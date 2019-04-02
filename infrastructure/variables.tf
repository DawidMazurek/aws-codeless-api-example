variable "bucket" {
  description = "AWS S3 Bucket name for Terraform state"
}
variable "key" {
  description = "Key for Terraform state at S3 bucket"
}
variable "region" {
  description = "AWS Region"
}
variable "stage" {
  description = "Stage of the environment"
}