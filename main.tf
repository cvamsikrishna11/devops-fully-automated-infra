# module to create IAM role and policy for the CloudWatch access
module "iam" {
  source = "./iam"
  name   = local.common_tags.company
  tags   = local.common_tags
}



# module code to create the ec2 instance with user data
module "ec2_dev" {
  source        = "./ec2"
  name          = "dev"
  tags          = local.common_tags
  iam_role_name = module.iam.ec2_iam_role_name
  key_pair_name = "vamsi-chunduru"
}

# module code to create the ec2 instance with user data.
module "ec2_stage" {
  source        = "./ec2"
  name          = "stage"
  tags          = local.common_tags
  iam_role_name = module.iam.ec2_iam_role_name
  key_pair_name = "vamsi-chunduru"
}

# module code to create the ec2 instance with user data
module "ec2_prod" {
  source        = "./ec2"
  name          = "prod"
  tags          = local.common_tags
  iam_role_name = module.iam.ec2_iam_role_name
  key_pair_name = "vamsi-chunduru"
}