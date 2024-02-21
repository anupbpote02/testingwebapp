
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

variable "PROJECT_ID" {
  type        = string
  description = "Google Cloud project ID"
  default     = env("PROJECT_ID")  
}

variable "SOURCE_IMAGE_FAMILY" {
  type        = string
  description = "Source image family for the VM"
  default     = env("SOURCE_IMAGE_FAMILY")  
}

variable "IMAGE_NAME" {
  type        = string
  description = "Name of the resulting VM image"
  default     = env("IMAGE_NAME")  
}

variable "IMAGE_FAMILY" {
  type        = string
  description = "Image family for the resulting VM image"
  default     = env("IMAGE_FAMILY")  
}

variable "ZONE" {
  type        = string
  description = "Google Cloud zone for the VM"
  default     = env("ZONE")  
}

variable "SSH_USERNAME" {
  type        = string
  description = "SSH username for the VM"
  default     = env("SSH_USERNAME")  
}


source "googlecompute" "basic-example" {
  project_id          = "${var.PROJECT_ID}"
  source_image_family = "${var.SOURCE_IMAGE_FAMILY}"
  image_name          = "${var.IMAGE_NAME}"
  image_family        = "${var.IMAGE_FAMILY}"
  zone                = "${var.ZONE}"
  credentials_json    = "${var.GCP_COMPUTE}"
  ssh_username        = "${var.SSH_USERNAME}"
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
  