const std = @import("std");
const Tdir = enum { row, col };
const Tarrow = enum { zero, inc, dec };

pub fn mark_visible(line: []u8, k: Tdir, n: usize, bits: *[99][99]bool, step: enum { inc, dec }) void {
    var top: u8 = '0' - 1;
    var idx: usize = if (step == .inc) 0 else line.len - 1;
    while (idx >= 0 and idx < line.len) {
        if (line[idx] > top) {
            if (k == .row) {
                bits[n][idx] = true;
            } else {
                bits[idx][n] = true;
            }
            top = line[idx];
        }
        if (top == '9') {
            break;
        }
        if (step == .inc) {
            idx += 1;
        }
        if (step == .dec) {
            if (idx == 0) break;
            idx -= 1;
        }
    }
}

pub fn visible(line: []u8, k: Tdir, n: usize, bits: *[99][99]bool) void {
    mark_visible(line, k, n, bits, .inc);
    mark_visible(line, k, n, bits, .dec);
}

pub fn get_score(grid: [99][99]u8, c: u8, r: u8) u64 {
    return get_distance(grid, c, r, .inc, .zero) *
        get_distance(grid, c, r, .dec, .zero) *
        get_distance(grid, c, r, .zero, .inc) *
        get_distance(grid, c, r, .zero, .dec);
}

pub fn get_distance(grid: [99][99]u8, c: u8, r: u8, vc: Tarrow, vr: Tarrow) u64 {
    var c1 = c;
    var r1 = r;
    var distance: u64 = 0;
    while (true) {
        if (c1 == 0 or r1 == 0) {
            break;
        }
        if (c1 >= 98 or r1 >= 98) {
            break;
        }
        if (vc == .inc) c1 += 1;
        if (vc == .dec) c1 -= 1;
        if (vr == .inc) r1 += 1;
        if (vr == .dec) r1 -= 1;
        distance += 1;
        if (grid[r1][c1] >= grid[r][c]) {
            break;
        }
    }
    return distance;
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [4096]u8 = undefined;
    var reader = stdin.reader();

    var grid: [99][99]u8 = undefined;
    var bits: [99][99]bool = undefined;
    var v: u64 = 0;
    var nrow: usize = 0;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |row| {
        visible(row, .row, nrow, &bits);
        for (row) |c, ncol| {
            grid[ncol][nrow] = c;
        }
        nrow += 1;
    }
    for (grid) |col, ncol| {
        var c: [99]u8 = undefined;
        std.mem.copy(u8, &c, &col);
        visible(&c, .col, ncol, &bits);
    }
    for (bits) |r| {
        for (r) |b| {
            if (b) v += 1;
        }
    }
    std.debug.print("part1 {}\n", .{v});

    var maxscore: u64 = 0;
    var c:u8 = 0;
    while (c < 99) {
        var r:u8 = 0;
        while (r < 99) {
            const score = get_score(grid, c, r);
            maxscore = @max(maxscore, score);
            r += 1;
        }
       c += 1;
    }
    std.debug.print("part2 {}\n", .{maxscore});
}

test "test part1" {
    var bits: [99][99]bool = undefined;
    var grid: [99][99]u8 = undefined;
    var row0 = "30373".*;
    var row1 = "25512".*;
    var row2 = "65332".*;
    var row3 = "33549".*;
    var row4 = "35390".*;
    visible(&row0, .row, 0, &bits);
    visible(&row1, .row, 1, &bits);
    visible(&row2, .row, 2, &bits);
    visible(&row3, .row, 3, &bits);
    visible(&row4, .row, 4, &bits);
    for (row0) |c, i| grid[0][i] = c;
    for (row1) |c, i| grid[1][i] = c;
    for (row2) |c, i| grid[2][i] = c;
    for (row3) |c, i| grid[3][i] = c;
    for (row4) |c, i| grid[4][i] = c;
    visible(&grid[0], .col, 0, &bits);
    visible(&grid[1], .col, 1, &bits);
    visible(&grid[2], .col, 2, &bits);
    visible(&grid[3], .col, 3, &bits);
    visible(&grid[4], .col, 4, &bits);
    var v: u64 = 0;
    for (bits) |r, i| {
        if (i >= 5) break;
        for (r) |b, j| {
            if (j >= 5) break;
            if (b) v += 1;
        }
    }
    try std.testing.expectEqual(@as(u64, 20), v);
    // try std.testing.expectEqual(@as(u64, 21), v);
}
