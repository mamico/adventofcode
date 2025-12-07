module main

import os
import datatypes

const split = '^'[0]
const start = 'S'[0]

fn main() {
	lines := os.read_lines(os.args[1])!.map(it.bytes())
	// PART1
	{
		mut splitting := 0
		mut pos := datatypes.Set[int]{}
		pos.add(lines[0].index(start))
		for line in lines {
			mut new_pos := datatypes.Set[int]{}
			for i in 0 .. line.len {
				c := line[i]
				if c == split && pos.exists(i) {
					splitting += 1
					pos.remove(i)
					if i > 0 {
						new_pos.add(i - 1)
					}
					if i < line.len - 1 {
						new_pos.add(i + 1)
					}
				}
			}
			pos = pos.union(new_pos)
		}
		println('PART1 ${splitting}')
	}
	// PART 2
	{
		pos := lines[0].index(start)
		mut cache := map[int]i64{}
		part2 := timelines(pos, lines[1..lines.len], mut cache)
		println('PART2 ${part2}')
	}
}

fn timelines(p int, lines [][]u8, mut cache map[int]i64) i64 {
	key := lines.len * lines[0].len + p
	if key in cache {
		return cache[key]
	}
	mut result := i64(0)
	if p < 0 || p >= lines[0].len {
		result = 0
	} else if lines.len == 1 {
		result = 1
	} else if lines[0][p] == split {
		result = timelines(p - 1, lines[1..lines.len], mut cache) + timelines(p +
			1, lines[1..lines.len], mut cache)
	} else {
		result = timelines(p, lines[1..lines.len], mut cache)
	}
	cache[key] = result
	return result
}
