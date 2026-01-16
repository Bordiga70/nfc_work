use sqlx::sqlite::SqlitePool;


use::axum::{
	Router,
	routing::{post},
	extract::State,
	response::Json,
	http::StatusCode,
};

use serde::{
    Serialize,
    Deserialize,
};

const IP: &str = "10.0.1.109:3000";

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> {
    let pool: SqlitePool = SqlitePool::connect_lazy("data.db").expect("Can't open database");
	
	let app = Router::new()
    	.route("/login", post(do_login))
		.route("/new", post(create_user))
		.with_state(pool);
	
	let listener = tokio::net::TcpListener::bind(IP).await.expect("Cannot bind to {IP}");
    println!("server ready!");
    axum::serve(listener, app).await.expect("Error starting the server");


    Ok(())
}

#[derive(Deserialize)]
#[derive(Serialize)]
struct User {
	tag: String,
}

async fn do_login(State(pool): State<SqlitePool>, Json(payload): Json<User>) -> StatusCode {

	let user = User {
		tag: payload.tag,
	};
	let mut conn = pool.acquire().await.unwrap();
	
	/*
	
	let mut conn = pool.acquire().await.unwrap();

	
	let exists = sqlx::query("SELECT 1 FROM Utente WHERE tag = ?")
		.bind(&user.tag)
		.fetch_optional(&mut *conn)
		.await.expect("reason");
	
	let mut conn = pool.acquire().await.unwrap();
	*/

	sqlx::query(
	r#"
	
		INSERT OR IGNORE INTO Presenza (tag, data)
		VALUES ($1, DATE('now', 'localtime'));

		WITH today AS (
			SELECT id_presenza
			FROM Presenza
			WHERE tag = $1
			  AND data = DATE('now', 'localtime')
			LIMIT 1
		)
		INSERT INTO Timbro (id_presenza, tipo, orario)
		SELECT 
			t.id_presenza,
			CASE 
				WHEN last.tipo IS NULL          THEN 'entrata'
				WHEN last.tipo = 'uscita'       THEN 'entrata'
				ELSE 'uscita'
			END,
			DATETIME('now', 'localtime')
		FROM today t
		LEFT JOIN (
			SELECT tipo
			FROM Timbro
			WHERE id_presenza = (SELECT id_presenza FROM today)
			ORDER BY orario DESC
			LIMIT 1
		) last;
	
	"#
	)
	.bind(&user.tag)
	.execute(&mut *conn)
	.await;
	
	return StatusCode::CREATED;
}

#[derive(Deserialize)]
struct Test {
	tag: String,
	name: String,
	surname: String
}

async fn create_user(State(pool): State<SqlitePool>, Json(payload): Json<Test>) -> StatusCode {
	
	let mut conn = pool.acquire().await.unwrap();
	
	let t = Test {
		tag: payload.tag,
		name: payload.name,
		surname: payload.surname,
	};
	
	sqlx::query(
	r#"
		INSERT INTO Utente (tag, nome, cognome)
		VALUES ($1, $2, $3);
	"#
	)
	.bind(t.tag)
	.bind(t.name)
	.bind(t.surname)
	.execute(&mut *conn)
	.await;
	
	return StatusCode::CREATED
}