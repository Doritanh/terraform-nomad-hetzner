data "hcloud_image" "nomad_arm64_snapshot" {
  with_selector = "name==nomad-arm64"
  with_architecture = "arm"
  most_recent   = true
}

data "hcloud_image" "nomad_x86_snapshot" {
  with_selector = "name==nomad-x86"
  with_architecture = "x86"
  most_recent   = true
}