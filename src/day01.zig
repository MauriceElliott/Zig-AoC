const std = @import("std");
const data = @embedFile("data/day01.txt");
const print = std.debug.print;

const splitAny = std.mem.splitAny;
const parseInt = std.fmt.parseInt;
const trim = std.mem.trim;
const sort = std.sort.block;
const asc = std.sort.asc;

pub fn main() !void {
    var rows = splitAny(u8, data, "\n");
    var left: [1000]u32 = undefined;
    var right: [1000]u32 = undefined;
    var index: u32 = 0;
    while (rows.next()) |row| {
        if (index == 1000) break;
        var row_split = splitAny(u8, row, "   ");
        const row_left = trim(u8, row_split.first(), " ");
        const row_right = trim(u8, row_split.rest(), " ");
        left[index] = try parseInt(u32, row_left, 10);
        right[index] = try parseInt(u32, row_right, 10);
        index += 1;
    }

    //part 1
    sort(u32, &left, {}, asc(u32));
    sort(u32, &right, {}, asc(u32));
    var total: u64 = 0;
    for (0..left.len) |i| {
        const diff: i64 = @as(i64, left[i]) - @as(i64, right[i]);
        total += @abs(diff);
    }
    print("total: {}", .{total});

    //part 2
    //to be continued
}
