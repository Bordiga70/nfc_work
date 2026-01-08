
/*
use axum::{
    routing::get,
    Router,
};

#[tokio::main]
async fn main() {
let app = Router::new()
    .route("/login", get(get_login))
    .route("/presenza", get(get_foo));

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await.unwrap();
    println!("server ready!");
    axum::serve(listener, app).await.unwrap();
}

async fn get_login() -> &'static str {
    println!("foo");
    return "foo";
}
async fn get_foo() -> &'static str {
    "foo foo"
}
*/

use postgres::{Client, NoTls};

fn main() -> Result<(), Box<dyn std::error::Error>> {

let mut client = Client::connect("host=localhost user=postgres", NoTls)?;

client.batch_execute("
    CREATE TABLE person (
        id      SERIAL PRIMARY KEY,
        name    TEXT NOT NULL,
        data    BYTEA
    )
")?;

let name = "Ferris";
let data = None::<&[u8]>;
client.execute(
    "INSERT INTO person (name, data) VALUES ($1, $2)",
    &[&name, &data],
)?;

for row in client.query("SELECT id, name, data FROM person", &[])? {
    let id: i32 = row.get(0);
    let name: &str = row.get(1);
    let data: Option<&[u8]> = row.get(2);

    println!("found person: {} {} {:?}", id, name, data);
}
Ok(())
}