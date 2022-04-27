// Criando VPC
resource "google_compute_network" "google_network_vpc" {
  name                    = "vpc-network-projeto-1"
  auto_create_subnetworks = false
}

// Criando Subnet
resource "google_compute_subnetwork" "google_network_subnet" {
  name          = "subnet-network-projeto-1"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.google_network_vpc.id
}

// Criando rota
resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.google_network_subnet.region
  network = google_compute_network.google_network_vpc.id
}

resource "google_compute_address" "address" {
  count  = 2
  name   = "nat-manual-ip-${count.index}"
  region = google_compute_subnetwork.google_network_subnet.region
}

// Criando cloud Nat
resource "google_compute_router_nat" "nat_manual" {
  name   = "router-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.google_network_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}