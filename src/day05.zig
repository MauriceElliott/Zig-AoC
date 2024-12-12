const std = @import("std");
const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05_sample.txt");

pub fn main() !void {
    var split = splitSeq(u8, data, "\n\n");
    var rules_rows = splitAny(u8, split.first(), "\n");
    var pages_rows = splitAny(u8, split.rest(), "\n");
    var rules: [21][2]u8 = undefined;
    var pages: [6][5]u8 = undefined;
    var index: usize = 0;

    while (rules_rows.next()) |row| {
        if (eql(u8, row, "")) continue;
        var jindex: usize = 0;
        var rules_row = tokenizeSeq(u8, row, "|");
        while (rules_row.next()) |val| {
            if (eql(u8, val, "")) continue;
            rules[index][jindex] = try parseInt(u8, val, 10);
            jindex += 1;
        }
        index += 1;
    }
    index = 0;
    while (pages_rows.next()) |row| {
        if (eql(u8, row, "")) continue;
        var jindex: usize = 0;
        var pages_row = tokenizeSeq(u8, row, ",");
        while (pages_row.next()) |val| {
            if (eql(u8, val, "")) continue;
            pages[index][jindex] = try parseInt(u8, val, 10);
            jindex += 1;
        }
        index += 1;
    }
}

// Useful stdlib functions
const tokenizeSeq = std.mem.tokenizeSequence;
const splitSeq = std.mem.splitSequence;
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

const print = std.debug.print;
