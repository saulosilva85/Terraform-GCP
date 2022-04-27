# allow all access from IAP and health check ranges
resource "google_compute_firewall" "fw-iap" {
  name          = "fw-allow-iap-hc"
  direction     = "INGRESS"
  network       = google_compute_network.google_network_vpc.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
  }
}

# allow http from proxy subnet to backends
resource "google_compute_firewall" "fw-backends" {
  name          = "fw-allow-backends"
  direction     = "INGRESS"
  network       = google_compute_network.google_network_vpc.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "allow-http", "allow-ssh"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

# // Criando regra SSH
resource "google_compute_firewall" "allow-ssh" {
  name          = "fw-allow-ssh"
  direction     = "INGRESS"
  network       = google_compute_network.google_network_vpc.id
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}