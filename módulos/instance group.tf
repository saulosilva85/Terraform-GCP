// Criando instance group
resource "google_compute_instance_group_manager" "instance_group" {
  name = "webserver-instance-group"
  base_instance_name = "vm-webserver"
  zone               = "us-central1-a"

  version {
    instance_template  = google_compute_instance_template.instance_template.id
  }

  named_port {
    name = "http"
    port = "80"
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

// Criando health check
resource "google_compute_health_check" "autohealing" {
  name                = "monitora-webserver"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    request_path = "/index.html"
    port         = "80"
  }
}

// Criando autoscaler
resource "google_compute_autoscaler" "autoscaler" {
  name   = "webserver-autoscaler"
  zone   = "us-central1-a"
  target = google_compute_instance_group_manager.instance_group.id


  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 120 // tempo de espera para começar a coletar dados da instancia.

    cpu_utilization {
      target = 0.8
    }
  }
}
