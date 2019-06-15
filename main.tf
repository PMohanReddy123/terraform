provider "aws" {
  region = "ap-south-1"

}
data "template_file" "init" {
  template = "${file("policy.json")}"
  vars = {
    s3_arn="${var.aws_s3_arn}"
  }
}
resource "aws_iam_policy" "policy_s3" {
  name        = "s3_policy"
  path        = "/"
  description = "My test policy"
  policy      = "${data.template_file.init.rendered}"
}
resource "aws_iam_role" "ec2_role" {
  name = "role_ec2"
  assume_role_policy = "${file("role.json")}"
  # tags = {
  #   tag-key = "tag-value"
  # }
}
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = "${aws_iam_role.ec2_role.name}"
  policy_arn = "${aws_iam_policy.policy_s3.arn}"
}
resource "aws_iam_instance_profile" "iam_profile" {
  name = "IAM_profile"
  role = "${aws_iam_role.ec2_role.name}"
}
