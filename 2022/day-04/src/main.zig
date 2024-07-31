// part1 + part2

const std = @import("std");

pub fn split(line: []u8, sep: u8) [2][]u8 {
    // 91-93,6-92
    var idx: u8 = 0;
    for (line) |c| {
        if (c == sep) {
            return [2][]u8{line[0..idx], line[idx+1..line.len]};
        }
        idx += 1;
    }
    return [2][]u8{line, line};
}

pub fn parseline(line: []u8) ![4]u8 {
    var splitted: [4][]u8 = split(split(line, ',')[0], '-') ++ split(split(line, ',')[1], '-');
    return [4]u8{
        try std.fmt.parseInt(u8, splitted[0], 10),
        try std.fmt.parseInt(u8, splitted[1], 10),
        try std.fmt.parseInt(u8, splitted[2], 10),
        try std.fmt.parseInt(u8, splitted[3], 10)
    };
}

pub fn overlap_1(line: []u8) !bool {
    const splitted: [4]u8 = parseline(line) catch |err| { return err; };
    return (
        (splitted[0] <= splitted[2] and splitted[1] >= splitted[3]) or
        (splitted[0] >= splitted[2] and splitted[1] <= splitted[3])
    );
}

pub fn overlap_2(line: []u8) !bool {
    const splitted: [4]u8 = parseline(line) catch |err| { return err; };
    return (
        (splitted[0] <= splitted[2] and splitted[1] >= splitted[2]) or
        (splitted[0] >= splitted[2] and splitted[0] <= splitted[3])
    );
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [64]u8 = undefined;
    var reader = stdin.reader();
    var t1: u32 = 0;
    var t2: u32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (overlap_1(line) catch { continue; }) {
            t1 += 1;
        }
        if (overlap_2(line) catch { continue; }) {
            t2 += 1;
        }
    }
    std.debug.print("Overlaps part 1 {}.\n", .{t1});
    std.debug.print("Overlaps part 2 {}.\n", .{t2});
}

test "test part 1" {
    var line1 = "91-93,6-92".*;
    var line2 = "2-8,3-7".*;
    try std.testing.expectEqual(false, overlap_1(&line1) catch |err| { return err; });
    try std.testing.expectEqual(true, overlap_1(&line2) catch |err| { return err; });
}

test "test part 2" {
    var line1 = "91-93,6-92".*;
    var line2 = "2-8,3-7".*;
    try std.testing.expectEqual(true, overlap_2(&line1) catch |err| { return err; });
    try std.testing.expectEqual(true, overlap_1(&line2) catch |err| { return err; });
}