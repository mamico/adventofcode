// part1

const std = @import("std");

pub fn priority_1(rucksack: []u8) u32 {
    var c1 = rucksack[0..rucksack.len / 2];
    var c2 = rucksack[rucksack.len / 2..rucksack.len];
    for (c1) |e1| {
        for (c2) |e2| {
            if (e1 == e2) {
                if (e1 >= 'a' and e1 <= 'z') {
                    return e1 - 'a' + 1;
                }
                else {  // A-Z
                    return e1 - 'A' + 27;
                }
            }
        }
    }
    return 0;
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [64]u8 = undefined;
    var reader = stdin.reader();
    var t1: u32 = 0;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        t1 += priority_1(line);
    }
    std.debug.print("Sum of priorities part 1 {}.\n", .{t1});
}

test "test part 1" {
    var pack1 = "vJrwpWtwJgWrhcsFMMfFFhFp".*;
    try std.testing.expectEqual(@as(u32, 16), priority_1(&pack1));
    var pack2 = "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL".*;
    try std.testing.expectEqual(@as(u32, 38), priority_1(&pack2));
    var pack3 = "PmmdzqPrVvPwwTWBwg".*;
    try std.testing.expectEqual(@as(u32, 42), priority_1(&pack3));
    var pack4 = "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn".*;
    try std.testing.expectEqual(@as(u32, 22), priority_1(&pack4));
    var pack5 = "ttgJtRGJQctTZtZT".*;
    try std.testing.expectEqual(@as(u32, 20), priority_1(&pack5));
    var pack6 = "CrZsJsPPZsGzwwsLwLmpwMDw".*;
    try std.testing.expectEqual(@as(u32, 19), priority_1(&pack6));
}
