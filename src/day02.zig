const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.

fn is_safe(report: *[8]u8) bool {
    const Direction = enum {
        increase,
        decrease,
    };
    var direction: Direction = undefined;
    if (report[0] > report[3]) {
        direction = Direction.decrease;
    } else {
        direction = Direction.increase;
    }
    for (0..report.len) |r| {
        if (r == 0) continue;
        const current: i32 = report[r];
        const previous: i32 = report[r - 1];
        if (current == 170) break;
        const diff = current - previous;
        if (diff > 3 or diff < -3 or diff == 0 or (diff < 0 and direction == Direction.increase) or (diff > 0 and direction == Direction.decrease)) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {

    //PARSE DATA
    var rows = splitAny(u8, data, "\n");
    var i: u32 = 0;
    var reports: [1000][8]u8 = undefined;
    while (rows.next()) |row| {
        if (i == 1000) break;
        var report = tokenizeSeq(u8, row, " ");
        var parsed_report: [8]u8 = undefined;
        var n: u8 = 0;
        while (report.next()) |node| {
            parsed_report[n] = try parseInt(u8, node, 10);
            n += 1;
        }
        reports[i] = parsed_report;
        i += 1;
    }

    var safe: u32 = 0;
    for (0..reports.len) |r| {
        if (is_safe(&reports[r])) {
            safe += 1;
        }
    }
    print("safe: {} \n", .{safe});
}
