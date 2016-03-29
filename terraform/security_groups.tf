resource "aws_security_group" "github_action_app" {
  name        = "github-action-app"
  description = "SecurityGroup for github_action_app"
  vpc_id      = "${aws_vpc.github_action.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    "Name" = "github_action_app"
  }
}

resource "aws_security_group_rule" "github_action_allow_ssh" {
  count = "${var.speee_ips_count}"

  type = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${lookup(var.speee_ips, count.index)}/32"]

  security_group_id = "${aws_security_group.github_action_app.id}"
}

resource "aws_security_group_rule" "github_action_allow_http" {
  count = "${var.speee_ips_count}"

  type = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["${lookup(var.speee_ips, count.index)}/32"]

  security_group_id = "${aws_security_group.github_action_app.id}"
}
