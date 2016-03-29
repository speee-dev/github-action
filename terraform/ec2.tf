resource "aws_instance" "github_action_app" {
  ami = "ami-f80e0596"
  instance_type = "t2.small"
  availability_zone = "ap-northeast-1a"
  subnet_id = "${aws_subnet.github_action_app_1a.id}"
  vpc_security_group_ids = [
    "${aws_security_group.github_action_app.id}"
  ]

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags {
    Name = "github_action_app"
  }

  user_data = <<EOT
#!/bin/bash
yum update -y

${join("\n", template_file.add_authorized_keys.*.rendered)}
EOT
}

resource "template_file" "add_authorized_keys" {
  count = "${var.public_keys_count}"
  template = "echo '${public_key}' >> /home/ec2-user/.ssh/authorized_keys"
  vars {
    public_key = "${lookup(var.public_keys, count.index)}"
  }
}

resource "aws_eip" "github_action_app" {
  instance = "${aws_instance.github_action_app.id}"
}
