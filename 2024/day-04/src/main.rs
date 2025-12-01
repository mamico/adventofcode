use std::fs::read_to_string;


fn search_mas(matrix: &Vec<Vec<char>>, i: usize, j: usize, di: i32, dj: i32) -> i32 {
    let mut i = i as i32;
    let mut j = j as i32;
    let chars = ['M', 'A', 'S'];
    for curr in 0..chars.len() {
        i += di;
        j += dj;
        if i < 0 || i >= matrix.len() as i32 || j < 0 || j >= matrix[i as usize].len() as i32 {
            return 0;
        }
        if matrix[i as usize][j as usize] != chars[curr] {
            return 0;
        }
    }
    return 1;
}

fn search_x_mas(matrix: &Vec<Vec<char>>, i: usize, j: usize) -> bool {
    return (
            (matrix[i-1][j-1] == 'S' && matrix[i+1][j+1] == 'M') || 
            (matrix[i+1][j+1] == 'S' && matrix[i-1][j-1] == 'M')
        ) &&
        (
            (matrix[i-1][j+1] == 'S' && matrix[i+1][j-1] == 'M') ||
            (matrix[i+1][j-1] == 'S' && matrix[i-1][j+1] == 'M')
        );

}

fn main() {
    let input_path = std::env::args().nth(1).expect("no path given");
    let mut matrix: Vec<Vec<char>> = Vec::new();
    for line in read_to_string(input_path).unwrap().lines() {
        matrix.push(line.chars().collect::<Vec<char>>());
    }
    // PART 1
    {
            let mut found = 0;
            for i in 1..matrix.len()-1 {
                for j in 1..matrix[i].len()-1 {
                    if matrix[i][j] == 'X' {
                        found += search_mas(&matrix, i, j, 1, 0);
                        found += search_mas(&matrix, i, j, 1, 1);
                        found += search_mas(&matrix, i, j, 0, 1);
                        found += search_mas(&matrix, i, j, -1, 1);
                        found += search_mas(&matrix, i, j, -1, 0);
                        found += search_mas(&matrix, i, j, -1, -1);
                        found += search_mas(&matrix, i, j, 0, -1);
                        found += search_mas(&matrix, i, j, 1, -1);
                    }
                }
            }
            println!("PART 1: {}", found);
    }
    // PART 2
    {
        let mut found = 0;
        for i in 1..matrix.len()-1 {
            for j in 1..matrix[i].len()-1 {
                if matrix[i][j] == 'A' {
                    if search_x_mas(&matrix, i, j) { 
                        found += 1;
                    }
                }
            }
        }
        println!("PART 2: {}", found);
    }
}
