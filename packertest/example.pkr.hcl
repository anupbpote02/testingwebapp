
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}



source "googlecompute" "basic-example" {
  project_id          = "csyedevcheck"
  source_image_family = "centos-stream-8"
  image_name          = "webapp-image"
  image_family        = "webapp-family"
  zone                = "us-east1-c"
  credentials_file    = ${{secrets.GCP_COMPUTE}}
  ssh_username        = "useraccount"
}

build {
  sources = ["sources.googlecompute.basic-example"]


  provisioner "shell" {
    script = "./test1firewall.sh"
  }

  provisioner "shell" {
    script = "./test1node.sh"
  }

  provisioner "shell" {
    script = "./test1sql.sh"
  }

  provisioner "file" {
    source      = "C:/Users/anupb/Music/webapp-main.zip"
    destination = "/tmp/webapp-main.zip"
  }

  provisioner "shell" {
    script = "./installstart.sh"
  }

  // provisioner "file" {
  //   source      = "./csye6225.service"
  //   destination = "/tmp/"
  // }

  provisioner "shell" {
    script = "./useradd.sh"
  }


}
  