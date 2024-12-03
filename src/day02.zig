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
const Direction = enum {
    increase,
    decrease,
};

fn isCausingAnOffense(diff: i32, direction: Direction) bool {
    if (diff > 3 or diff < -3 or diff == 0 or (diff < 0 and direction == Direction.increase) or (diff > 0 and direction == Direction.decrease)) {
        return true;
    }
    return false;
}

fn isSafe(report: *[8]u8) bool {
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
        if (isCausingAnOffense(diff, direction)) {
            return false;
        }
    }
    return true;
}

fn isAlmostSafe(report: *[8]u8) bool {
    var direction: Direction = undefined;
    if (report[0] > report[3]) {
        direction = Direction.decrease;
    } else {
        direction = Direction.increase;
    }
    var offense_index: usize = 0;
    var retry = false;
    for (0..report.len) |r| {
        if (r == 0) continue;
        const current: i32 = report[r];
        const previous: i32 = report[r - 1];
        if (current == 170) break;
        const diff = current - previous;
        if (isCausingAnOffense(diff, direction)) {
            offense_index = r;
            retry = true;
            break;
        }
    }
    if (retry) {
        var one_not_offensive: bool = true;
        var two_not_offensive: bool = true;
        var three_not_offensive: bool = true;
        var previous: i32 = 0;
        for (0..report.len) |r| {
            var offense_detected: bool = false;
            const current: i32 = report[r];
            if (current == 170) break;
            if (r == offense_index) {
                offense_detected = true;
            }
            if (r > 0 and offense_detected == false) {
                const diff = current - previous;
                if (isCausingAnOffense(diff, direction)) {
                    one_not_offensive = false;
                    break;
                }
            }
            previous = current;
        }
        for (0..report.len) |r| {
            var offense_detected: bool = false;
            const current: i32 = report[r];
            if (current == 170) break;
            if (r == (offense_index + 1)) {
                offense_detected = true;
            }
            if (r > 0 and offense_detected == false) {
                const diff = current - previous;
                if (isCausingAnOffense(diff, direction)) {
                    two_not_offensive = false;
                    break;
                }
            }
            previous = current;
        }
        for (0..report.len) |r| {
            var offense_detected: bool = false;
            const current: i32 = report[r];
            if (current == 170) break;
            if (r == (offense_index - 1)) {
                offense_detected = true;
            }
            if (r > 0 and offense_detected == false) {
                const diff = current - previous;
                if (isCausingAnOffense(diff, direction)) {
                    three_not_offensive = false;
                    break;
                }
            }
            previous = current;
        }
        return (one_not_offensive or two_not_offensive or three_not_offensive);
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
        if (isSafe(&reports[r])) {
            safe += 1;
        }
    }

    print("safe: {} \n", .{safe});

    var almost_safe: u32 = 0;
    for (0..reports.len) |r| {
        if (isAlmostSafe(&reports[r])) {
            almost_safe += 1;
        }
    }

    print("almost safe: {}\n", .{almost_safe});
}
