const std = @import("std");
const TypeVisited = std.HashMap([2]i64, bool, std.hash_map.AutoContext([2]i64), std.hash_map.default_max_load_percentage);

pub fn move(H: *[2]i64, T: *[2]i64, dir: u8, head: bool) void {
    if (head) {
        switch (dir) {
            'R' => H[0] += 1,
            'L' => H[0] -= 1,
            'U' => H[1] += 1,
            'D' => H[1] -= 1,
            else => unreachable,
        }
    }
    // T[0] += @divTrunc(H[0] - T[0], 2);
    // T[1] += @divTrunc(H[1] - T[1], 2);
    if ((H[0] - T[0] == 2 or H[0] - T[0] == -2) and (H[1] - T[1] == 2 or H[1] - T[1] == -2)) {
        T[0] += @divTrunc(H[0] - T[0], 2);
        T[1] += @divTrunc(H[1] - T[1], 2);
    }
    else if (H[0] - T[0] == 2) {
        T[0] += @divTrunc(H[0] - T[0], 2);
        T[1] = H[1];
    }
    else if (H[0] - T[0] == -2) {
        T[0] += @divTrunc(H[0] - T[0], 2);
        T[1] = H[1];
    } 
    else if (H[1] - T[1] == 2) {
        T[1] += @divTrunc(H[1] - T[1], 2);
        T[0] = H[0];
    } 
    else if (H[1] - T[1] == -2) {
        T[1] += @divTrunc(H[1] - T[1], 2);
        T[0] = H[0];
    }
}

pub fn move1(H: *[2]i64, T: *[2]i64, line: []const u8, visited: *TypeVisited) void {
    const dir = line[0];
    var dist = std.fmt.parseInt(u64, line[2..], 10) catch unreachable;
    while (dist > 0) {
        move(H, T, dir, true);
        visited.put(T.*, true) catch unreachable;
        dist -= 1;
    }
}

pub fn move2(rope: *[10][2]i64, line: []const u8, visited: *TypeVisited) void {
    const dir = line[0];
    var dist = std.fmt.parseInt(u64, line[2..], 10) catch unreachable;
    while (dist > 0) {
        var i: usize = 0;
        while (i < 9) {
            move(&rope[i], &rope[i + 1], dir, i==0);
            i += 1;
        }
        visited.put(rope[9], true) catch unreachable;
        dist -= 1;
    }
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [4096]u8 = undefined;
    var reader = stdin.reader();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    // part 1 - a short rope
    var H = [2]i64{ 0, 0 };
    var T = [2]i64{ 0, 0 };
    var visited1 = TypeVisited.init(allocator);
    defer visited1.deinit();

    // part 2 - a long rope (10)
    var rope = [10][2]i64{
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
    };
    var visited2 = TypeVisited.init(allocator);
    defer visited2.deinit();

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        move1(&H, &T, line, &visited1);
        move2(&rope, line, &visited2);
    }

    std.debug.print("part1 {}\n", .{visited1.count()});
    std.debug.print("part2 {}\n", .{visited2.count()});
}

test "test part1" {
    const allocator = std.testing.allocator;
    var visited = TypeVisited.init(allocator);
    defer visited.deinit();
    const input = [_][]const u8{
        "R 4",
        "U 4",
        "L 3",
        "D 1",
        "R 4",
        "D 1",
        "L 5",
        "R 2",
    };
    var H = [2]i64{ 0, 0 };
    var T = [2]i64{ 0, 0 };
    std.debug.print("\n", .{});
    for (input) |line| {
        move1(&H, &T, line, &visited);
    }
    try std.testing.expectEqual(@as(u64, 13), visited.count());
}

test "test part2" {
    const allocator = std.testing.allocator;
    var visited = TypeVisited.init(allocator);
    defer visited.deinit();
    const input = [_][]const u8{
        "R 5",
        "U 8",
        "L 8",
        "D 3",
        "R 17",
        "D 10",
        "L 25",
        "U 20",
    };
    var rope = [10][2]i64{
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
        [2]i64{ 0, 0 },
    };

    for (input) |line| {
        move2(&rope, line, &visited);
    }
    try std.testing.expectEqual(@as(u64, 36), visited.count());
}
