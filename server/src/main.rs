use axum::{
    routing::{get, post},
    http::StatusCode,
    Router, Json,
};

use sqlite::{
    State,
    Connection,
};

use serde::{
    Serialize,
    Deserialize,
};

#[tokio::main]
async fn main() {
    let app = Router::new()
    	.route("/login", post(do_login));
    //	.route("/verify", post(test))

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await.unwrap();
    println!("server ready!");
    axum::serve(listener, app).await.unwrap();
}

fn connect_to_db(path: &str) -> Connection {
     let connection = match sqlite::open(path) {
	Ok(connection) => connection,
	Err(_) => panic!("Impossibile connettersi al DB"),
     };
     connection
}

#[derive(Debug)]
struct Person {
	id: i64,
	codice_fiscale: String,
	nome: String,
	cognome: String,
}

async fn create_user(username: &String, password: &String) -> Option<Person> {
    let connection = connect_to_db(r"data.db");
	
    let query =	format!("SELECT id_persona FROM Login WHERE username = '{}' AND password = '{}'", username, password);
    let mut statement = connection.prepare(query).unwrap();

    if statement.next().unwrap() != State::Row {
	return None;
    }

    let person_id = statement.read::<i64, _>("id_persona").unwrap();

    println!("person id: {}", person_id);
    	
    let query = format!("SELECT * FROM Persona WHERE id = '{}'", person_id);
    let mut statement = connection.prepare(query).unwrap();
    
    if statement.next().unwrap() != State::Row {
	return None;
    }

    let p = Person {
		id: statement.read::<i64, _>("id").unwrap(),
		codice_fiscale: statement.read::<String, _>("codice_fiscale").unwrap(),
		nome: statement.read::<String, _>("nome").unwrap(),
		cognome: statement.read::<String, _>("cognome").unwrap(),
    	};
    return Some(p);
}

async fn verify_login(username: &String, password: &String) ->  bool {
    let connection = connect_to_db(r"data.db");
	
    let query =	format!("SELECT id_persona FROM Login WHERE username = '{}' AND password = '{}'", username, password);
    let mut statement = connection.prepare(query).unwrap();

    let _ = statement.next();
    let person_id = statement.read::<i64, _>("id_persona").unwrap();

    if person_id != 0 {
    	return true;
    }

    return false;
}

#[derive(Deserialize)]
struct LoginRequest {
	username: String,
	password: String,
}

#[derive(Serialize)]
struct LoginMessage {
	id: u32,
	codice_fiscale: String,
}

async fn do_login(Json(payload): Json<LoginRequest>) -> StatusCode {

    println!("received username: {}", payload.username);
    println!("received password: {}", payload.password);

    let p = create_user(&payload.username, &payload.password).await;
    println!("{:?}", p);

    if verify_login(&payload.username, &payload.password).await {
    	return StatusCode::CREATED;	
    }

    return StatusCode::NOT_FOUND;
}

/*
async fn test(Json(payload): Json<Person>) -> StatusCode {

    println!("received id: {}", payload.id);
    println!("received codice_fiscale: {}", payload.codice_fiscale);

    let connection = connect_to_db(r"data.db");
    let query = format!("INSERT INTO Presenza VALUES("{0}", NOW())", payload.id);
    connection.execute(query).unwrap();

    return StatusCode::NOT_FOUND;
}
*/