// part1 + part2

const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [8]u8 = undefined;
    var reader = stdin.reader();
    var maxval: u32 = 0;
    var top3: [3]u32 = std.mem.zeroes([3]u32);
    var sum: u32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (std.mem.eql(u8, line, "")) {
            if (sum > maxval) {
                maxval = sum;
            }
            if (sum > top3[0]) {
                top3[2] = top3[1];
                top3[1] = top3[0];
                top3[0] = sum;
            }
            else if (sum > top3[1]) {
                top3[2] = top3[1];
                top3[1] = sum;
            }
            else if (sum > top3[2]) {
                top3[2] = sum;
            }
            sum = 0;
        }
        else {
            sum += try std.fmt.parseInt(u32, line, 10);
        }
    }
    if (sum > maxval) {
        maxval = sum;
    }

    std.debug.print("Elf with more cals has {} cals.\n", .{maxval});
    std.debug.print("Top three Elfs with more cals have {} cals.\n", .{top3[0] + top3[1] + top3[2]});
}

// test "simple test" {
//     var list = std.ArrayList(i32).init(std.testing.allocator);
//     defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
//     try list.append(42);
//     try std.testing.expectEqual(@as(i32, 42), list.pop());
// }
