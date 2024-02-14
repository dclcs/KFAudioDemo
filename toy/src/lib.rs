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


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn one_test() {
        let instructions = "";
        // assert!();
    }
}