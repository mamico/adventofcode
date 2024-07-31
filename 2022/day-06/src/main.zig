// step 1 + step 2

const std = @import("std");

pub fn find_seq_1(line: []u8) u64 {
    var i: u64 = 0;
    while (i < line.len) {
        if (line[i] == line[i + 1] or line[i] == line[i + 2] or line[i] == line[i + 3]) {
            i += 1;
        } else if (line[i + 1] == line[i + 2] or line[i + 1] == line[i + 3]) {
            i += 2;
        } else if (line[i + 2] == line[i + 3]) {
            i += 3;
        } else {
            return i + 4;
        }
    }
    return 0;
}

pub fn check(line: []u8) u64 {
    var i: u64 = line.len - 2;
    while (i > 0) {
        if (line[line.len - 1] == line[i]) {
            return i;
        }
        i -= 1;
    }
    return 0;
}

pub fn find_seq_2(line: []u8, length: u64) u64 {
    var min: u64 = 0;
    var i: u64 = 2;
    var skip: u64 = 0;
    var message: []u8 = undefined;
    while (i < line.len) {
        message = line[min..i];
        skip = check(message);
        if (skip == 0) {
            if (message.len >= length) {
                return i + 1;
            } else {
                i += 1;
            }
        } else {
            min += skip;
            i += 1;
        }
    }
    return 0;
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [4096]u8 = undefined;
    var reader = stdin.reader();

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        std.debug.print("part1 {}\n", .{find_seq_1(line)});
        std.debug.print("part2 {}\n", .{find_seq_2(line, 14)});
    }
}

test "test part1" {
    var line1 = "bvwbjplbgvbhsrlpgdmjqwftvncz".*; // : first marker after character 5
    var line2 = "nppdvjthqldpwncqszvftbrmjlhg".*; //: first marker after character 6
    var line3 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".*; //: first marker after character 10
    var line4 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".*; //: first marker after character 11

    try std.testing.expectEqual(@as(u64, 5), find_seq_1(&line1));
    try std.testing.expectEqual(@as(u64, 6), find_seq_1(&line2));
    try std.testing.expectEqual(@as(u64, 10), find_seq_1(&line3));
    try std.testing.expectEqual(@as(u64, 11), find_seq_1(&line4));

    try std.testing.expectEqual(@as(u64, 5), find_seq_2(&line1, 4));
}

test "test part2" {
    var line1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb".*; //: first marker after character 19
    var line2 = "bvwbjplbgvbhsrlpgdmjqwftvncz".*; //: first marker after character 23
    var line3 = "nppdvjthqldpwncqszvftbrmjlhg".*; //: first marker after character 23
    var line4 = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".*; //: first marker after character 29
    var line5 = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".*; //: first marker after character 26
    try std.testing.expectEqual(@as(u64, 19), find_seq_2(&line1, 14));
    try std.testing.expectEqual(@as(u64, 23), find_seq_2(&line2, 14));
    try std.testing.expectEqual(@as(u64, 23), find_seq_2(&line3, 14));
    try std.testing.expectEqual(@as(u64, 29), find_seq_2(&line4, 14));
    try std.testing.expectEqual(@as(u64, 26), find_seq_2(&line5, 14));
}
