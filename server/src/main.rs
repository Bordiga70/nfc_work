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