module main
import os
import strconv

struct Range {
	start i64
	end i64
}

fn main() {
	// PART 1
	{
		mut ranges := []Range{}
		mut total := 0
		mut p0 := true
		for line in os.read_lines(os.args[1])! {
			if line == "" {
				p0 = false
				continue
			}
			if p0 {
				ranges << Range{
					strconv.atoi64(line.split("-")[0])!,
					strconv.atoi64(line.split("-")[1])!
				}
			}
			else {
				id := strconv.atoi64(line)!
				for r in ranges {
					if r.start <= id && id <= r.end {
						total += 1
						break
					}
				}
			}
		}
		println('Part 1 - ${total}')
	}

	// PART 2
	{
		mut ranges := []Range{}
		for line in os.read_lines(os.args[1])! {
			if line == "" {
				break
			}
			ranges << Range{
				strconv.atoi64(line.split("-")[0])!,
				strconv.atoi64(line.split("-")[1])!
			}
		}
		ranges.sort(a.start < b.start)
		mut end := ranges[0].end
		mut total := ranges[0].end - ranges[0].start + 1
		for i in 1..ranges.len {
			if ranges[i].start <= end {
				if ranges[i].end > end {
					total += ranges[i].end - end
					end = ranges[i].end
				}
				continue
			}
			total += ranges[i].end - ranges[i].start + 1
			end = ranges[i].end
		}
		println('Part 2 - ${total}')
	}
}