// step 1 + step 2

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

pub fn parseline(line: []u8) ![3]u8 {
    // move 7 from 3 to 9
    const n1 = try std.fmt.parseInt(u8, split(split(line, ' ')[1], ' ')[0], 10);
    const n2 = try std.fmt.parseInt(u8, split(split(split(split(line, ' ')[1], ' ')[1], ' ')[1], ' ')[0], 10);
    const n3 = try std.fmt.parseInt(u8, split(split(split(split(split(line, ' ')[1], ' ')[1], ' ')[1], ' ')[1], ' ')[1], 10);
    return [3]u8{
        n1, n2 - 1, n3 - 1,
    };
}

pub fn main() !void {
    // [T] [V]                     [W]
    // [V] [C] [P] [D]             [B]
    // [J] [P] [R] [N] [B]         [Z]
    // [W] [Q] [D] [M] [T]     [L] [T]
    // [N] [J] [H] [B] [P] [T] [P] [L]
    // [R] [D] [F] [P] [R] [P] [R] [S] [G]
    // [M] [W] [J] [R] [V] [B] [J] [C] [S]
    // [S] [B] [B] [F] [H] [C] [B] [N] [L]
    //  1   2   3   4   5   6   7   8   9
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var stacks = [9]std.ArrayList(u8){
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
        std.ArrayList(u8).init(arena.allocator()),
    };
    try stacks[0].appendSlice("SMRNWJVT");
    try stacks[1].appendSlice("BWDJQPCV");
    try stacks[2].appendSlice("BJFHDRP");
    try stacks[3].appendSlice("FRPBMND");
    try stacks[4].appendSlice("HVRPTB");
    try stacks[5].appendSlice("CBPT");
    try stacks[6].appendSlice("BJRPL");
    try stacks[7].appendSlice("NCSLTZBW");
    try stacks[8].appendSlice("LSG");

    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [64]u8 = undefined;
    var reader = stdin.reader();
    var i:u8 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (line.len == 0 or line[0] != 'm') {
            continue;
        }
        // move 7 from 3 to 9
        const move = parseline(line) catch { continue; };

        // STEP 1
        // i = 0;
        // while (i < move[0]) {
        //     try stacks[move[2]].append(stacks[move[1]].pop());
        //     i += 1;
        // }

        // STEP 2
        try stacks[move[2]].appendSlice(stacks[move[1]].items[stacks[move[1]].items.len-move[0]..]);
        stacks[move[1]].items.len -= move[0];
    }

    i=0;
    while (i < 9) {
        std.debug.print("{c}", .{stacks[i].pop()});
        i+=1;
    }
    std.debug.print("\n", .{});
}

test "parseline test" {
    var line = "move 7 from 3 to 9".*;
    const parsed: [3]u8 = try parseline(&line);
    try std.testing.expectEqual(@as(u8, 7), parsed[0]);
    try std.testing.expectEqual(@as(u8, 3), parsed[1]);
    try std.testing.expectEqual(@as(u8, 9), parsed[2]);
}

