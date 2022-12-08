// part1 + part2

const std = @import("std");

pub fn score_1(opponent: u8, you: u8) u32 {
    // A,X: Rock, B,Y: Paper, C,Z: Scissors
    var score: u32 = @as(u32, you - 'W');
    // std.debug.print("Elf with more cals has {} {} cals.\n", .{you, score});
    if (you - 'X' == opponent - 'A') {
        return score + 3;
    }
    else if ((you - 'X') == (opponent - 'A' + 1) % 3) {
        return score + 6;
    }
    else {
        return score;
    }
}

pub fn score_2(opponent: u8, res: u8) u32 {
    // A: Rock, B: Paper, C: Scissors
    // X: lose, Y: draw, Z: win
    if (res == 'X') {
        return score_1(opponent, 'X' + (opponent - 'A' + 2) % 3);
    }
    if (res == 'Y') {
        return score_1(opponent, opponent - 'A' + 'X');
    }
    else {  // 'Z'
        return score_1(opponent, 'X' + (opponent - 'A' + 1) % 3);
    }
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [8]u8 = undefined;
    var reader = stdin.reader();
    var t1: u32 = 0;
    var t2: u32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        t1 += score_1(line[0], line[2]);
        t2 += score_2(line[0], line[2]);
        // std.debug.print("{s} {}.\n", .{line, score_1(line[0], line[2])});
    }
    std.debug.print("Score part 1 {}.\n", .{t1});
    std.debug.print("Score part 2 {}.\n", .{t2});
}

test "test part 1" {
    try std.testing.expectEqual(@as(u32, 8), score_1('A', 'Y'));
    try std.testing.expectEqual(@as(u32, 1), score_1('B', 'X'));
    try std.testing.expectEqual(@as(u32, 6), score_1('C', 'Z'));
}

test "test part 2" {
    try std.testing.expectEqual(@as(u32, 4), score_2('A', 'Y'));
    try std.testing.expectEqual(@as(u32, 1), score_2('B', 'X'));
    try std.testing.expectEqual(@as(u32, 7), score_2('C', 'Z'));
}
