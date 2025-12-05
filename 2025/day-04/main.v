module main
import os

fn main() {
	// PART 1
	{
		mut grid := [][]int{}
		mut total := 0
		for line in os.read_lines(os.args[1])! {
			grid << line.split("").map(
				fn (it string) int {
					if it == '.' { return 9 } else { return 0 } 
				}
			)
		}
		for i in 0..grid[0].len {
			for j in 0..grid.len {
				for ii in [i-1, i, i+1] {
					for jj in [j-1, j, j+1] {
						if ii == i && jj == j {
							continue
						}
						if ii >= 0 && ii < grid[0].len && jj >= 0 && jj < grid.len && grid[ii][jj] < 9 {
							grid[i][j]++
						}
					}
				}
			}
		}
		for i in 0..grid[0].len {
			for j in 0..grid.len {
				if grid[i][j] < 4 {
					total++
				}
			}
		}
		// total := arrays.sum(grid.map(arrays.sum(it.map(fn (it int) int {if it < 4 {return 1} else {return 0}}))!))!
		println('Part 1 - ${total}')
	}

	// PART 2
	{
		mut grid := [][]int{}
		mut total := 0
		for line in os.read_lines(os.args[1])! {
			grid << line.split("").map(
				fn (it string) int {
					if it == '.' { return 9 } else { return 0 } 
				}
			)
		}
		for true {
			for i in 0..grid[0].len {
				for j in 0..grid.len {
					for ii in [i-1, i, i+1] {
						for jj in [j-1, j, j+1] {
							if ii == i && jj == j {
								continue
							}
							if ii >= 0 && ii < grid[0].len && jj >= 0 && jj < grid.len && grid[ii][jj] < 9 {
								grid[i][j]++
							}
						}
					}
				}
			}
			mut f := 0
			for i in 0..grid[0].len {
				for j in 0..grid.len {
					if grid[i][j] < 4 {
						f++
						grid[i][j] = 9
					}
					else if grid[i][j] < 9{
						grid[i][j] = 0
					}
				}
			}
			if f == 0 {
				break
			}
			total += f
		}
		println('Part 2 - ${total}')
	}
}