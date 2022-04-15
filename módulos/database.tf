//Criando id do banco de dados
resource "google_sql_database_instance" "instance" {
  name             = "db-teste-01"
  database_version = "mysql_5_7"  
  region           = "us-east1"

  settings {
    tier = "db-f1-micro"
  }
}

  // Criando banco de dados
resource "google_sql_database" "database" {
  name     = "teste"
  instance = google_sql_database_instance.instance.name
}

  //Criando usuário
resource "google_sql_user" "users" {
  name     = "informar um nome de usuário"
  password = "informar uma senha para o usuário"
  instance = google_sql_database_instance.instance.name
}
