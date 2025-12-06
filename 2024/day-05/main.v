module main

import os
import strconv
import datatypes

struct Rule {
	n int
	r datatypes.Set[int]
}

fn main() {
	mut rules := map[int]datatypes.Set[int]{}
	mut part1 := 0
	mut part2 := 0
	mut p0 := true
	for line in os.read_lines(os.args[1])! {
		if line == '' {
			p0 = false
			continue
		}
		if p0 {
			a := strconv.atoi(line.split('|')[0])!
			b := strconv.atoi(line.split('|')[1])!
			if a !in rules {
				rules[a] = datatypes.Set[int]{}
			}
			rules[a].add(b)
		} else {
			pages := line.split(',').map(strconv.atoi(it)!)
			mut sorted := true
			for i := 0; i < pages.len - 1; i++ {
				mut sub := datatypes.Set[int]{}
				sub.add_all(pages[i + 1..pages.len])
				if !rules[pages[i]].subset(sub) {
					sorted = false
					break
				}
			}
			if sorted {
				part1 += pages[pages.len / 2]
			} else {
				part2 += pages.map(Rule{it, rules[it]}).sorted_with_compare(fn (a &Rule, b &Rule) int {
					if a.r.exists(b.n) {
						return -1
					}
					if b.r.exists(a.n) {
						return 1
					}
					return 0
				})[pages.len / 2].n
			}
		}
	}
	println('Part 1 - ${part1}')
	println('Part 2 - ${part2}')
}
