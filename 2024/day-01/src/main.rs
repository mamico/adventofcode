use std::fs::read_to_string;
use regex::Regex;

fn main() {
    // PART 1
    {
        let input_path = std::env::args().nth(1).expect("no path given");
        let mut left = Vec::new();
        let mut right = Vec::new();
        let re = Regex::new(r"[ \t]+").unwrap();
        for line in read_to_string(input_path).unwrap().lines() {
            let v = re.split(line).collect::<Vec<&str>>();
            left.push(v[0].to_string().parse::<i32>().unwrap());
            right.push(v[1].to_string().parse::<i32>().unwrap());
        }
        left.sort();
        right.sort();
        let mut sum = 0;
        for i in 0..left.len() {
            sum += (left[i] - right[i]).abs();
        }
        println!("PART1 {}", sum);
    }
    // PART 2
    {
        let input_path = std::env::args().nth(1).expect("no path given");
        let mut left = Vec::new();
        let mut right = Vec::new();
        let re = Regex::new(r"[ \t]+").unwrap();
        for line in read_to_string(input_path).unwrap().lines() {
            let v = re.split(line).collect::<Vec<&str>>();
            left.push(v[0].to_string().parse::<i32>().unwrap());
            right.push(v[1].to_string().parse::<i32>().unwrap());
        }
        let mut sum = 0;
        for i in 0..left.len() {
            let count = right.iter().filter(|x| **x == left[i]).count() as i32;
            sum += left[i] * count;
        }
        println!("PART2 {}", sum);
    }
}
