use std::fs::read_to_string;


fn main() {
    // PART 1
    {    
        let input_path = std::env::args().nth(1).expect("no path given");
        let mut count = 0;
        let mut pos = 50;
        for line in read_to_string(input_path).unwrap().lines() {
            let op = line.chars().next().unwrap();
            let val = line[1..].parse::<i32>().unwrap();            
            pos += if op == 'L' { -val } else { val };
            pos %= 100;
            if pos == 0 {
                count += 1;
            }
        }
        println!("PART 1 {}", count);
    }
    // PART 2
    {    
        let input_path = std::env::args().nth(1).expect("no path given");
        let mut count = 0;
        let mut pos = 50;
        for line in read_to_string(input_path).unwrap().lines() {
            let op = line.chars().next().unwrap();
            let val = line[1..].parse::<i32>().unwrap();            
            if op == 'L' {
                let extra = if pos!=0 && val % 100 >= pos { 1 } else { 0 };
                count += (val / 100) + extra;
                if val <= pos {
                    pos = (val - pos).abs();
                } else {
                    pos = 100 - (val % 100) + pos;
                }
                pos %= 100;
            } else {
                pos += val;
                count += pos / 100;
                pos %= 100;
            }
            // println!("=> ({}) => {} -- {} ", line, pos, count);
        }
        println!("PART 2 {}", count);
    }
}