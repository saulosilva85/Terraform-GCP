// Criando Loadbalance
resource "google_compute_url_map" "loadbalance" {
  name            = "loadbalance-webserver"
  default_service = google_compute_backend_service.backend_service.id
}

// Criando loadbalance backend service
resource "google_compute_backend_service" "backend_service" {
  name                  = "lb-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.autohealing.id]


  backend {
    group           = google_compute_instance_group_manager.instance_group.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

// Criando Loadbalance frontend service
resource "google_compute_global_forwarding_rule" "frontend_service" {
  name                  = "lb-frontend-service"
  ip_protocol           = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.id
  ip_address            = google_compute_global_address.ip_address.id
}

// Criando reserva de IP address
resource "google_compute_global_address" "ip_address" {
  name = "lb-webserver"
}

// Criando http proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.loadbalance.id
}