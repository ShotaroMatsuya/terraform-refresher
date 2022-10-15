# Create a Null Resource and provisioners

resource "null_resource" "name" {
  # Local Exec Provisioner: local-exec provisioner (Create-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
  }
}
