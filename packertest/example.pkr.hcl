
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

variable "GCP_COMPUTE" {

  type= string
  description= "storing creds"
  default = env("GCP_COMPUTE")
}

source "googlecompute" "basic-example" {
  project_id          = "csyecloud"
  source_image_family = "centos-stream-8"
  image_name          = "webapp-image"
  image_family        = "webapp-family"
  zone                = "us-east1-c"
  credentials_json    = "${var.GCP_COMPUTE}"
  ssh_username        = "useraccount"
}

build {
  sources = ["sources.googlecompute.basic-example"]


  provisioner "shell" {
    script = "packertest/test1firewall.sh"
  }

  provisioner "shell" {
    script = "packertest/test1node.sh"
  }

  provisioner "shell" {
    script = "packertest/test1sql.sh"
  }

  provisioner "file" {
    source      = "./webapp-main.zip"
    destination = "/tmp/webapp-main.zip"
  }

  provisioner "shell" {
    script = "packertest/installstart.sh"
  }

  // provisioner "file" {
  //   source      = "./csye6225.service"
  //   destination = "/tmp/"
  // }

  provisioner "shell" {
    script = "packertest/useradd.sh"
  }


}
  