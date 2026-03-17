variable "cloud_id" {
  type        = string
  default     = "b1gj2n9n1isp9elpqjgg"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1go27l8hvlv5894e0fr"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

#Network
variable "vpc_name" {
  type        = string
  default     = "kafka-network"
  description = "VPC network & subnet name"
}

#Instances kafka
variable "kafka_resources" {
  type = map(object({
    core     = number
    memory   = number
    fraction = number
    count    = number
  }))
  default = {
    kafka = {
      count    = 3
      core     = 2
      memory   = 4
      fraction = 20
    }
  }
}

#Instances akhq
variable "akhq_resources" {
  type = map(object({
    core     = number
    memory   = number
    fraction = number
    count    = number
  }))
  default = {
    akhq = {
      count    = 1
      core     = 2
      memory   = 4
      fraction = 20
    }
  }
}

variable "family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "The name of the image family to which this image belongs"
}
