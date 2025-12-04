module main
import os
import strconv
import arrays
import math.stats


fn main() {
	mut banks := os.read_lines(os.args[1])!.map(it.split("").map(strconv.atoi64(it)!))
	{
		mut total := i64(0)
		for bank in banks {
			h := stats.max_index(bank[..bank.len-1])
			l := stats.max_index(bank[h+1..bank.len]) + h + 1
			total += bank[h]*10 + bank[l]
		}
		println('Part 1 - ${total}')
		
		total = 0
		for mut bank in banks {
			for i:=0; i < bank.len-1 && bank.len > 12;  {
				if bank[i] < bank[i+1] {
					bank = arrays.concat(bank[0..i], ...bank[i+1..bank.len])
					i = 0
				} else {
					i+=1
				}
			}
			bank = bank[0..12].clone()
			j := strconv.atoi64(bank.map("${it}").join(""))!
			total += j
		}
		println('Part 2 - ${total}')
	}
}