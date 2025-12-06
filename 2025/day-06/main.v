module main

import os
import strconv
import arrays

fn main() {
	// PART 1
	{
		lines := os.read_lines(os.args[1])!
		ops := lines[lines.len-1].split(' ').filter(it != '')
		mut values := lines[0].split(' ').filter(it != '').map(strconv.atoi64(it)!)
		for line in lines[1..lines.len-1].map(it.split(' ').filter(it != '').map(strconv.atoi64(it)!)) {
			for i in 0..values.len {
				if ops[i] == "*" {
					values[i] *= line[i]
				}
				else {
					values[i] += line[i]
				}
			}
		}
		part1 := arrays.sum(values)!
		println("PART1 ${part1}")
	}
	// PART 2
	{
		lines := os.read_lines(os.args[1])!
		mut cols := lines[0].split("").map("0")
		for i in 0..lines[0].len {
			for j in 0..lines.len-1 {
				if lines[j][i].ascii_str() != " " {
					cols[i] = "${cols[i]}${lines[j][i].ascii_str()}"
				}
			}
		}
		mut op := ""
		mut partial := i64(0)
		mut part2 := i64(0)
		for i in 0..lines[0].len {
			next_op := lines[lines.len-1][i].ascii_str()
			n := strconv.atoi64(cols[i])!
			if n == 0 {
				continue
			}
			if  next_op == "*" {
				part2 += partial
				partial = n
				op = "*"
			}
			else if next_op == "+"{	
				part2 += partial
				partial = n
				op = "+"
			}
			else if op == "*" {
				partial *= n
			}
			else {  // +
				partial += n
			}
		}
		part2 += partial
		println("PART2 ${part2}")
	}
}
