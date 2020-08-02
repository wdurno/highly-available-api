provider "google" {
 credentials = file("../../service-account.json") 
 project     = "gdax-dnn"
 region      = "us-central1-a"
}
