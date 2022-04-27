//Criando id do banco de dados
resource "google_sql_database_instance" "instance" {
  name             = "db-teste-01"
  database_version = "mysql_5_7"  
  region           = "us-east1"

  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}

  // Criando banco de dados
resource "google_sql_database" "database" {
  name     = "webserver"
  instance = google_sql_database_instance.instance.name
}

  //Criando usuario
resource "google_sql_user" "users" {
  name     = "teste"
  password = "1234"
  instance = google_sql_database_instance.instance.name
}
