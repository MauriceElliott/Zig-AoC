const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const eql = std.mem.eql;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day05_sample.txt");

fn enforceRules(rules: *[]const u8, pages: *[]const u8) ![]u8 {
    for (0..rules.len) |i| {
        for (0..pages.len) |j| {}
    }
}

pub fn main() !void {
    var split = splitSeq(u8, data, "\n\n");
    var rules_rows = splitAny(u8, split.first(), "\n");
    var pages_rows = splitAny(u8, split.rest(), "\n");
    var rules: [21][2]u8 = undefined;
    var pages: [6][5]u8 = undefined;
    var index: usize = 0;

    while (rules_rows.next()) |row| {
        print("row: {s}\n", .{row});
        if (eql(u8, row, "")) continue;
        var jindex: usize = 0;
        var rules_row = tokenizeSeq(u8, row, "|");
        while (rules_row.next()) |val| {
            if (eql(u8, val, "")) continue;
            rules[index][jindex] = try parseInt(u8, val, 10);
            print("rules: {}\n", .{rules[index][jindex]});
            jindex += 1;
        }
        index += 1;
    }
    index = 0;
    while (pages_rows.next()) |row| {
        print("row: {s}\n", .{row});
        if (eql(u8, row, "")) continue;
        var jindex: usize = 0;
        var pages_row = tokenizeSeq(u8, row, ",");
        while (pages_row.next()) |val| {
            if (eql(u8, val, "")) continue;
            pages[index][jindex] = try parseInt(u8, val, 10);
            print("pages: {}\n", .{pages[index][jindex]});
            jindex += 1;
        }
        index += 1;
    }
}

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
