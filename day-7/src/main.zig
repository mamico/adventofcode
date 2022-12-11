// step 1 + step 2

const std = @import("std");

pub fn split(line: []u8, sep: u8) [2][]u8 {
    // 91-93,6-92
    var idx: u8 = 0;
    for (line) |c| {
        if (c == sep) {
            return [2][]u8{ line[0..idx], line[idx + 1 .. line.len] };
        }
        idx += 1;
    }
    return [2][]u8{ line, line };
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [4096]u8 = undefined;
    var reader = stdin.reader();
    var cmd: enum { none, ls } = .none;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var cwd = std.ArrayList([]u8).init(allocator);
    var du = std.StringHashMap(u64).init(allocator);
    var curr: []u8 = undefined;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (line[0] == '$') {
            if (std.mem.eql(u8, line, "$ cd ..")) {
                cwd.items.len -= 1; // aka pop
                cmd = .none;
            } else if (std.mem.eql(u8, line, "$ cd /")) {
                var root = "/".*;
                cwd.items.len = 0;                
                try cwd.append(&root);
                cmd = .none;
            } else if (std.mem.eql(u8, line[0..4], "$ cd")) {
                curr = try allocator.alloc(u8, cwd.items[cwd.items.len - 1].len + 1 + line.len - 5);
                for (cwd.items[cwd.items.len - 1]) |c,i| {
                    curr[i] = c;
                }
                    for (line[5..line.len]) |c,i| {
                    curr[cwd.items[cwd.items.len - 1].len + i] = c;
                }
                curr[cwd.items[cwd.items.len - 1].len + line.len - 5] = '/';
                try cwd.append(curr);
                cmd = .none;
            } else {
                if (du.contains(cwd.items[cwd.items.len - 1])) {
                     cmd = .none;
                } else {
                     cmd = .ls;
                }
            }
        } else if (std.mem.eql(u8, line[0..4], "dir ")) {
            // dir ljtdcgt - SKIP
        } else {
            if (cmd == .ls) {
                for (cwd.items) |d| {
                    try du.put(d, (du.get(d) orelse 0) +
                        (std.fmt.parseInt(u64, split(line, ' ')[0], 10) catch |err| {
                        return err;
                    }));
                }
            }
        }
    }

    var sum: u64 = 0;
    var values = du.valueIterator();
    var todel :u64 = 70000000;
    const total: u64 = du.get("/") orelse 0; 
    while (values.next()) |s| {
        // part 1
        sum += if (s.* <= @as(u64, 100000)) s.* else 0;
        // part 2
        if (70000000 - total + s.* >= 30000000  and s.* < todel) {
            todel = s.*;
        }
    }

    std.debug.print("part1 {}\n", .{sum});
    std.debug.print("part2 {}\n", .{todel});
}

test "test part1" {}

test "test part2" {}
