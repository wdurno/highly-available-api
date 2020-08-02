resource "google_container_cluster" "ha-demo-cluster" {
  name     = "ha-demo-cluster"
  location = "us-central1-a"

  initial_node_count       = 3
  
  master_auth {
    username = ""
    password = ""
    
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  
  addons_config {
    http_load_balancing {
      disabled = false
    }
  }
  
  node_config {
    preemptible  = false
    machine_type = "e2-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }
  
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

