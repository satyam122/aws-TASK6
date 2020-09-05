provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_service" "service" {
  metadata {
    name = "wordpress"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    session_affinity = "ClientIP"
    port {
      port        =    80
      target_port = 80
      node_port = 30100
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "wordpress"
    labels = {
       app = "wordpress"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
         app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

        }
      }
    }
  }
}