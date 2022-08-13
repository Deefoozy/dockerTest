// use actix_web::{get, post, Responder, HttpServer, HttpResponse, App, web};

// #[actix_web::main]
// async fn main() -> std::io::Result<()> {
//     println!("Hello, world!");
//     HttpServer::new(|| {
//         App::new()
//             .service(test)
//             .service(
//                 web::scope("counters")
//                     .service(get_counters)
//                     .service(get_counter)
//                     .service(post_counter)
//             )
//
//     })
//     .bind(("127.0.0.1", 8080))?
//     .run()
//     .await
// }
//
// #[get("/")]
// async fn test() -> impl Responder {
//     HttpResponse::Ok().body("Hello world!")
// }
//
// #[get("/")]
// async fn get_counters() -> impl Responder {
//     HttpResponse::Ok().body("Hello world!")
// }
//
// #[get("/{counter_id}")]
// async fn get_counter(counter_id: String) -> impl Responder {
//     HttpResponse::Ok().body("Hello world! ".to_owned() + &counter_id)
// }
//
// #[post("/")]
// async fn post_counter(req_body: String, counter_id: String) -> impl Responder {
//     HttpResponse::Ok().body("Hello world! ".to_owned() + &req_body + &" " + &counter_id)
// }

fn main() {
    println!("Hello, world!");
}
