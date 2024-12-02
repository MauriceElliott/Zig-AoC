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

pub fn main() !void {

    //PARSE DATA
    var rows = splitAny(u8, data, "\n");
    var i: u32 = 0;
    var reports: [1000][8]u8 = undefined;
    while (rows.next()) |row| {
        if (i == 1000) break;
        var report = tokenizeSeq(u8, row, " ");
        var parsed_report: [8]u8 = undefined;
        var j: u8 = 0;
        while (report.next()) |node| {
            parsed_report[j] = try parseInt(u8, node, 10);
            j += 1;
        }
        reports[i] = parsed_report;
        i += 1;
    }

    //PART 1
    const safe: u32 = 1000;
    var notsafe: u32 = 0;
    var elsecount: u32 = 0;
    var safeincreaseamount: u32 = 0;
    var safedecreaseamount: u32 = 0;
    var unsafeincreaseamount: u32 = 0;
    var unsafedecreaseamount: u32 = 0;
    var percievedsafe: u32 = 0;
    var previousnodeunsafe: u32 = 0;
    for (0..reports.len) |r| {
        unsafeincreaseamount = 0;
        unsafedecreaseamount = 0;
        safeincreaseamount = 0;
        safedecreaseamount = 0;
        var previous_node: u8 = 0;
        var should_increase: ?bool = null;
        for (0..reports[r].len) |n| {
            const current_node: u8 = reports[r][n];
            if (n > 0) {
                if (current_node > previous_node and (should_increase == null or should_increase == true)) {
                    should_increase = true;
                    const safe_increase = previous_node + 3;
                    if (current_node <= safe_increase) {
                        safeincreaseamount = current_node;
                        percievedsafe = safe_increase;
                    } else {
                        unsafeincreaseamount = current_node;
                        previousnodeunsafe = previous_node;
                        percievedsafe = safe_increase;
                        notsafe += 1;
                        break;
                    }
                } else if (current_node < previous_node and (should_increase == null or should_increase == false)) {
                    should_increase = false;
                    const safe_decrease = previous_node - 3;
                    if (current_node >= safe_decrease) {
                        safedecreaseamount = current_node;
                    } else {
                        unsafedecreaseamount = current_node;
                        notsafe += 1;
                        break;
                    }
                } else {
                    elsecount += 1;
                    notsafe += 1;
                    break;
                }
            }
            previous_node = current_node;
        }
        if (r == 998) break;
    }
    print("elsecount: {}\n", .{elsecount});
    print("safe: {}\n", .{safe - notsafe});
    print("decreasecamount: {}\n", .{safedecreaseamount});
    print("increasecamount: {}\n", .{safeincreaseamount});
    print("unsafedecreaseamount {}\n", .{unsafedecreaseamount});
    print("unsafeincreaseamount {}\n", .{unsafeincreaseamount});
    print("percieved {}\n", .{percievedsafe});
    print("prev {}\n", .{previousnodeunsafe});
}
