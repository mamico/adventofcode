// part1 + part2

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

pub fn priority_2(rs1: []u8, rs2: []u8, rs3: []u8) u32 {
    for (rs1) |c1| {
        for (rs2) |c2| {
            if (c1 == c2) {
                for (rs3) |c3| {
                    if (c3 == c1) {
                        if (c1 >= 'a' and c1 <= 'z') {
                            return c1 - 'a' + 1;
                        }
                        else {  // A-Z
                            return c1 - 'A' + 27;
                        }
                    }
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
    var idx: u8 = 0;
    var t1: u32 = 0;
    var t2: u32 = 0;
    var r = [3][64]u8{ undefined, undefined, undefined };
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        t1 += priority_1(line);
        std.mem.copy(u8, &r[idx], line);
        if (idx == 2) {
            t2 += priority_2(&r[0], &r[1], &r[2]);
            r = [3][64]u8{undefined, undefined, undefined};
        }
        idx = (idx + 1) % 3;
    }
    std.debug.print("Sum of priorities part 1 {}.\n", .{t1});
    std.debug.print("Sum of priorities part 2 {}.\n", .{t2});
}

test "test part 1" {
    var rucksack1 = "vJrwpWtwJgWrhcsFMMfFFhFp".*;
    var rucksack2 = "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL".*;
    var rucksack3 = "PmmdzqPrVvPwwTWBwg".*;
    var rucksack4 = "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn".*;
    var rucksack5 = "ttgJtRGJQctTZtZT".*;
    var rucksack6 = "CrZsJsPPZsGzwwsLwLmpwMDw".*;
    try std.testing.expectEqual(@as(u32, 16), priority_1(&rucksack1));
    try std.testing.expectEqual(@as(u32, 38), priority_1(&rucksack2));
    try std.testing.expectEqual(@as(u32, 42), priority_1(&rucksack3));
    try std.testing.expectEqual(@as(u32, 22), priority_1(&rucksack4));
    try std.testing.expectEqual(@as(u32, 20), priority_1(&rucksack5));
    try std.testing.expectEqual(@as(u32, 19), priority_1(&rucksack6));
}

test "test part 2" {
    var rucksack1 = "vJrwpWtwJgWrhcsFMMfFFhFp".*;
    var rucksack2 = "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL".*;
    var rucksack3 = "PmmdzqPrVvPwwTWBwg".*;
    var rucksack4 = "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn".*;
    var rucksack5 = "ttgJtRGJQctTZtZT".*;
    var rucksack6 = "CrZsJsPPZsGzwwsLwLmpwMDw".*;
    try std.testing.expectEqual(@as(u32, 18), priority_2(&rucksack1, &rucksack2, &rucksack3));
    try std.testing.expectEqual(@as(u32, 52), priority_2(&rucksack4, &rucksack5, &rucksack6));
}