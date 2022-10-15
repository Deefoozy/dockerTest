use std::env::VarError;
use std::process::exit;
use actix_web::{get, post, Responder, HttpServer, HttpResponse, App, web};
use tokio_postgres::{NoTls, Error};
use tokio;
use dotenv::dotenv;

fn check_env_key(key: &str) -> String {
    let result:Result<String,VarError> = std::env::var(key);

    if result.is_err() {
        println!("Key {} is missing", key.to_string());

        exit(1);
    }

    result.unwrap()
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("Loading ENV");

    dotenv().ok();
    check_env_key("DB_USER");
    check_env_key("DB_PASSWORD");

    println!("Loaded ENV");
    println!("Starting server");

    HttpServer::new(|| {
        App::new()
            .service(test)
            .service(
                web::scope("/counters")
                    .service(get_counters)
                    .service(get_counter)
                    .service(post_counter)
            )

    })
    .bind(("0.0.0.0", 80))?
    .run()
    .await
}

#[get("/")]
async fn test() -> impl Responder {
    println!("Get");

    let res:Result<(),Error> = banaan().await;

    if res.is_err() {
        return HttpResponse::Unauthorized().body("Borked!");
    }

    return HttpResponse::Ok().body("Hello world!");
}

#[get("/")]
async fn get_counters() -> impl Responder {
    println!("Get counters");

    HttpResponse::Ok().body("Hello world!")
}

#[get("/{counter_id}")]
async fn get_counter(counter_id: String) -> impl Responder {
    println!("Get counter");

    HttpResponse::Ok().body("Hello world! ".to_owned() + &counter_id)
}

#[post("/{counter_id}")]
async fn post_counter(req_body: String, counter_id: String) -> impl Responder {
    println!("Post counters");

    HttpResponse::Ok().body("Hello world! ".to_owned() + &req_body + &" " + &counter_id)
}

async fn banaan() -> Result<(), Error> {
    let user:String = check_env_key("DB_USER");
    let password:String = check_env_key("DB_PASSWORD");

    // Connect to the database.
    let (client, connection) =
        tokio_postgres::connect(format!("host=postgres user={} password={}", user, password).as_str(), NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    let _rows = client
        .prepare("CREATE DATABASE test")
        .await?;

    Ok(())
}
