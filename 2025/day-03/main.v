module main
import os
import strconv
// import arrays
import math.stats


fn main() {
	banks := os.read_lines(os.args[1])!.map(it.split("").map(strconv.atoi(it)!))
	{
		mut total := 0
		for bank in banks {
			h := stats.max_index(bank[..bank.len-1])
			l := stats.max_index(bank[h+1..bank.len]) + h + 1
			println('${h}\t${l}\t${bank[h]}${bank[l]}')
			total += bank[h]*10 + bank[l]
		}
		println('Part 1 - ${total}')
	}
}