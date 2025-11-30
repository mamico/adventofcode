use std::fs::read_to_string;
use regex::Regex;

fn _is_safe(v: &Vec<i32>) -> bool {
    let mut inc = 0;  // 0: undef, >0: decrease, <0: increase
    for i in 0..v.len() - 1 {
        if v[i] - v[i + 1] > 0 && inc < 0 {
            return false;
        } else if v[i] - v[i + 1] < 0 && inc > 0 {
            return false;
        } else if v[i] - v[i + 1] == 0 {
            return false;
        } else if v[i] - v[i + 1] > 3 || v[i] - v[i + 1] < -3 {
            return false;
        }
        inc = v[i] - v[i + 1];
    }
    return true;
}

fn main() {
    // PART 1
    {
        let input_path = std::env::args().nth(1).expect("no path given");
        let re = Regex::new(r"[ \t]+").unwrap();
        let mut safe = 0;
        for line in read_to_string(input_path).unwrap().lines() {
            let v = re.split(line).collect::<Vec<&str>>().iter().map(|x| x.parse::<i32>().unwrap()).collect::<Vec<i32>>();
            let is_safe = _is_safe(&v);
            // println!("{} {}", line, is_safe);
            if is_safe {
                safe += 1;
            }
        }
        println!("PART1 {}", safe);
    }
    // PART 2
    {
        let input_path = std::env::args().nth(1).expect("no path given");
        let re = Regex::new(r"[ \t]+").unwrap();
        let mut safe = 0;
        for line in read_to_string(input_path).unwrap().lines() {
            let v = re.split(line).collect::<Vec<&str>>().iter().map(|x| x.parse::<i32>().unwrap()).collect::<Vec<i32>>();
            let mut is_safe;
            is_safe = _is_safe(&v);
            if !is_safe {
                for i in 0..v.len() {
                    is_safe = _is_safe(
                        &v.iter()
                            .enumerate()
                            .filter(|&(j, _)| j as i32 != i as i32)
                            .map(|(_,e)| *e)
                            .collect::<Vec<i32>>());
                    if is_safe {
                        break;
                    }
                }   
            }
            // println!("{} {}", line, is_safe);
            if is_safe {
                safe += 1;
            }
        }
        println!("PART2 {}", safe);
    }    
}