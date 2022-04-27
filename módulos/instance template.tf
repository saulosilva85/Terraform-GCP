// Criando template
resource "google_compute_instance_template" "instance_template" {
  name         = "webserver-template"
  machine_type = "e2-micro"

  tags = ["http-server", "https-server"]

  labels = {
    so = "debian"
    app = "webserver"
  }

  network_interface {
    network    = google_compute_network.google_network_vpc.id
    subnetwork = google_compute_subnetwork.google_network_subnet.id
    /*access_config {
      # add external ip to fetch packages
    }*/
  }

  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  // Instalação Apache, webserver
  metadata_startup_script = "apt update && apt -y install apache2 && apt -y install stress"
}