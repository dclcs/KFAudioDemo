use std::{env, process};
use toy::Config;

fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::new(&args).unwrap_or_else(|err| {
       eprintln!("Problem parsing arguments : {}", err);
        process::exit(1);
    });

    println!("{:?}", config);

    // 默认解析目录 ../AVDemo
    // 默认解析json ../demo.json
}
