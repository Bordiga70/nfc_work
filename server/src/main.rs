use axum::{
    routing::{get, post},
    http::StatusCode,
    Router, Json,
};

use sqlite::{
    State,
    Connection,
};

use std::fmt::{
    Debug,
    Formatter,
};

use serde::{
    Serialize,
    Deserialize,
};

#[tokio::main]
async fn main() {
    let app = Router::new()
    	.route("/login", post(do_login));

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

async fn verify_login(username: &String, password: &String) ->  bool {
    let connection = connect_to_db(r"data.db");

    let query = "SELECT * FROM Login";
    let mut statement = connection.prepare(query).unwrap();

    while let Ok(State::Row) = statement.next() {
	let current_username = statement.read::<String, _>("username").unwrap();
 	let current_password = statement.read::<String, _>("password").unwrap();

	if current_username == *username && current_password == *password {
			return true;
		}
    }
    return false;
}

async fn do_login(Json(payload): Json<LoginRequest>) -> (StatusCode, Json<CreateLoginResponse>) {

    println!("received username: {}", payload.username);
    println!("received password: {}", payload.password);

    let l = CreateLoginResponse {
	message: format!("message"),
    };

    if verify_login(&payload.username, &payload.password).await {
    	return (StatusCode::CREATED, Json(l));	
    }

    return (StatusCode::NOT_FOUND, Json(l));
}

#[derive(Deserialize)]
struct LoginRequest {
	username: String,
	password: String,
}

#[derive(Serialize)]
struct CreateLoginResponse {
	message: String,
}
