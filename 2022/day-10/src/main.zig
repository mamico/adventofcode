const std = @import("std");

const CPU = struct {
    const This = @This();
    clock: i32 = 0,
    x: i32 = 0,
    signals: std.ArrayList(i32) = undefined,
    crt_row: [40]u8 = .{0} ** 40,

    pub fn init(allocator: std.mem.Allocator) This {
        return This{
            .clock = 1,
            .x = 1,
            .signals = std.ArrayList(i32).init(allocator),
        };
    }
    
    pub fn deinit(self: *This) void {
        self.signals.deinit();
    }
    
    pub fn noop(self: *This) void {
        self.tick();
    }
    
    pub fn addx(self: *This, value: i32) void {
        self.tick();
        self.tick();
        self.x += value;
    }

    pub fn tick(self: *This) void {
        const col = @mod(self.clock - 1, @intCast(i32, self.crt_row.len));
        self.crt_row[@intCast(usize, col)] = if (col >= self.x - 1 and col <= self.x + 1) '#' else ' ';
        self.signals.append(self.x * self.clock) catch unreachable;
        self.clock += 1;
        if (@intCast(usize, self.clock) % self.crt_row.len == 0) {
            std.debug.print("{s}\n", .{self.crt_row});
        }
    }

    pub fn exec(self: *This, line: []const u8) !void {
        if (std.mem.eql(u8, line[0..4], "noop")) {
            self.noop();
        } else if (std.mem.eql(u8, line[0..4], "addx")) {
            self.addx(std.fmt.parseInt(i32, line[5..], 10) catch unreachable);
        } else {
            unreachable;
        }
    }

};

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [4096]u8 = undefined;
    var reader = stdin.reader();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    var cpu = CPU.init(allocator);
    defer cpu.deinit();
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        cpu.exec(line) catch unreachable;
    }

    var cycle:usize = 20;
    var sum:i32 = 0;
    std.debug.print("\n", .{});
    while (cycle <= cpu.signals.items.len) : (cycle += 40) {
        std.debug.print("{d}: {d}\n", .{cycle, cpu.signals.items[cycle - 1]});
        sum += cpu.signals.items[cycle - 1];
    }

    std.debug.print("part1 {d}\n", .{sum});
}

test "test part1" {
    const input = [_][]const u8{
        "addx 15",
        "addx -11",
        "addx 6",
        "addx -3",
        "addx 5",
        "addx -1",
        "addx -8",
        "addx 13",
        "addx 4",
        "noop",
        "addx -1",
        "addx 5",
        "addx -1",
        "addx 5",
        "addx -1",
        "addx 5",
        "addx -1",
        "addx 5",
        "addx -1",
        "addx -35",
        "addx 1",
        "addx 24",
        "addx -19",
        "addx 1",
        "addx 16",
        "addx -11",
        "noop",
        "noop",
        "addx 21",
        "addx -15",
        "noop",
        "noop",
        "addx -3",
        "addx 9",
        "addx 1",
        "addx -3",
        "addx 8",
        "addx 1",
        "addx 5",
        "noop",
        "noop",
        "noop",
        "noop",
        "noop",
        "addx -36",
        "noop",
        "addx 1",
        "addx 7",
        "noop",
        "noop",
        "noop",
        "addx 2",
        "addx 6",
        "noop",
        "noop",
        "noop",
        "noop",
        "noop",
        "addx 1",
        "noop",
        "noop",
        "addx 7",
        "addx 1",
        "noop",
        "addx -13",
        "addx 13",
        "addx 7",
        "noop",
        "addx 1",
        "addx -33",
        "noop",
        "noop",
        "noop",
        "addx 2",
        "noop",
        "noop",
        "noop",
        "addx 8",
        "noop",
        "addx -1",
        "addx 2",
        "addx 1",
        "noop",
        "addx 17",
        "addx -9",
        "addx 1",
        "addx 1",
        "addx -3",
        "addx 11",
        "noop",
        "noop",
        "addx 1",
        "noop",
        "addx 1",
        "noop",
        "noop",
        "addx -13",
        "addx -19",
        "addx 1",
        "addx 3",
        "addx 26",
        "addx -30",
        "addx 12",
        "addx -1",
        "addx 3",
        "addx 1",
        "noop",
        "noop",
        "noop",
        "addx -9",
        "addx 18",
        "addx 1",
        "addx 2",
        "noop",
        "noop",
        "addx 9",
        "noop",
        "noop",
        "noop",
        "addx -1",
        "addx 2",
        "addx -37",
        "addx 1",
        "addx 3",
        "noop",
        "addx 15",
        "addx -21",
        "addx 22",
        "addx -6",
        "addx 1",
        "noop",
        "addx 2",
        "addx 1",
        "noop",
        "addx -10",
        "noop",
        "noop",
        "addx 20",
        "addx 1",
        "addx 2",
        "addx 2",
        "addx -6",
        "addx -11",
        "noop",
        "noop",
        "noop",
    };

    // The interesting signal strengths c,an be determined as follows:
    // During the 20th cycle, register X has the value 21, so the signal strength is 20 * 21 = 420. (The 20th cycle occurs in the middle of the second addx -1, so the value of register X is the starting value, 1, plus all of the other addx values up to that point: 1 + 15 - 11 + 6 - 3 + 5 - 1 - 8 + 13 + 4 = 21.)
    // During the 60th cycle, register X has the value 19, so the signal strength is 60 * 19 = 1140.
    // During the 100th cycle, register X has the value 18, so the signal strength is 100 * 18 = 1800.
    // During the 140th cycle, register X has the value 21, so the signal strength is 140 * 21 = 2940.
    // During the 180th cycle, register X has the value 16, so the signal strength is 180 * 16 = 2880.
    // During the 220th cycle, register X has the value 18, so the signal strength is 220 * 18 = 3960.
    // The sum of these signal strengths is 13140.

    var cpu = CPU.init(std.testing.allocator);
    defer cpu.deinit();
    // var sum:i32 = 0;
    std.debug.print("\n", .{});
    for (input) |line| {
        cpu.exec(line) catch unreachable;
    }
    var cycle:usize = 20;
    var sum:i32 = 0;
    std.debug.print("\n", .{});
    while (cycle <= cpu.signals.items.len) : (cycle += 40) {
        std.debug.print("{d}: {d}\n", .{cycle, cpu.signals.items[cycle - 1]});
        sum += cpu.signals.items[cycle - 1];
    }
    try std.testing.expectEqual(@as(i32, 13140), sum);
}

test "test simple" {
    const input = [_][]const u8{
        "noop",
        "addx 3",
        "addx -5",
    };
    var cpu = CPU.init(std.testing.allocator);
    defer cpu.deinit();
    for (input) |line| {
        cpu.exec(line) catch unreachable;
    }
    std.debug.print("\nsignals: {any}\n", .{cpu.signals.items});
    try std.testing.expectEqual(@as(i32, 20), cpu.signals.items[4]);
}
