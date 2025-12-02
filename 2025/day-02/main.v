module main
import os
import strconv
import arrays

fn invalid(b i64, e i64) ([]i64){
	mut r := []i64{}
	for i in  b  .. (e + 1) {
		s := "${i}"
		if s[..s.len/2] == s[s.len/2..] {
			r << i
		}
	}
	return r
}

fn invalid_2(b i64, e i64) ([]i64){
	mut r := []i64{}
	for i in  b  .. (e + 1) {
		s := "${i}"
		mut invalid := false
		for j in 1..s.len/2 + 1 {
			if s.len % j == 0 {
				count := s.len / j
				mut jj := []int{}
				for it in 0..count {
					jj << it
				}
				invalid = jj.map(s[it*j..it*j+j]).all(it == s[0..j]) 
				if invalid {
					break
				}
			}
		}
		if invalid {
			r << i
		}
	}
	return r
}

fn main() {
	view_content := os.read_file(os.args[1])!
	{
		ranges := view_content.split(",")
			.map(it.trim("\n"))
			.map(it.split("-")
				.map(strconv.atoi64(it)!)
			)
			.map(invalid(it[0], it[1]))
		total := arrays.sum(arrays.flatten(ranges))!
		println('Part 1 - ${total}')
	}
	{
		ranges := view_content.split(",")
			.map(it.trim("\n"))
			.map(it.split("-")
				.map(strconv.atoi64(it)!)
			)
			.map(invalid_2(it[0], it[1]))
		total := arrays.sum(arrays.flatten(ranges))!
		println('Part 2 - ${total}')
	}

}