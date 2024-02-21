
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

variable "DB_NAME" {
  type        = string
  description = "Database name"
  default     = env("DB_NAME")
}

variable "DB_USER" {
  type        = string
  description = "Database user"
  default     = env("DB_USER")
}

variable "DB_PASSWORD" {
  type        = string
  description = "Database password"
  default     = env("DB_PASSWORD")
}

variable "DB_HOST" {
  type        = string
  description = "Database host"
  default     = env("DB_HOST")
}

variable "MYSQL_USER" {
  type        = string
  description = "MySQL user"
  default     = env("MYSQL_USER")
}

variable "MYSQL_PASSWORD" {
  type        = string
  description = "MySQL password"
  default     = env("MYSQL_PASSWORD")
}

variable "MYSQL_DATABASE" {
  type        = string
  description = "MySQL database name"
  default     = env("MYSQL_DATABASE")
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
    environment_vars = {
      MYSQL_USER       = "${var.MYSQL_USER}"
      MYSQL_PASSWORD   = "${var.MYSQL_PASSWORD}"
      MYSQL_DATABASE   = "${var.MYSQL_DATABASE}"
    }
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

    environment_vars = {
      DB_NAME       = "${var.DB_NAME}"
      DB_USER       = "${var.DB_USER}"
      DB_PASSWORD   = "${var.DB_PASSWORD}"
      DB_HOST       = "${var.DB_HOST}"
    }

  }


}
  