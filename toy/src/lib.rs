use std::fs;

#[derive(Debug)]
pub struct Config {
    pub instruction : String
}

impl Config {
    pub fn new(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 1 {
            return Err("not enough arguments");
        }
        let mut instruction :String = String::from("");
        if args.len() >= 2 {
            println!("args : {:?}", args);
            instruction = args[1].clone();
        }

        Ok(Config { instruction })
    }
}


pub fn parse_toy_demos(path: String, json_path: String) {
    println!("{:?} and {:?}", path, json_path);
    let dir = fs::read_dir(path).unwrap();
    for entry in dir {
        let entry = entry.unwrap();
        println!("{:?}", entry.path());
        let file_type = entry.file_type().unwrap();
        
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn one_test() {
        let project_path = String::from("../AVDemo/ViewControllers");
        let demo_json = String::from("../demo.json");
        parse_toy_demos(project_path,demo_json);
        // assert!();
    }
}