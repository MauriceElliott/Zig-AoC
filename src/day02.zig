const std = @import("std");
const data = @embedFile("data/day02.txt");
const tokenizeSeq = std.mem.tokenizeSequence;
const splitAny = std.mem.splitAny;
const print = std.debug.print;
const parseInt = std.fmt.parseInt;

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
    if (report[0] > report[3] and report[0] > report[2]) {
        direction = Direction.decrease;
    } else if (report[0] < report[4] and report[0] < report[2]) {
        direction = Direction.increase;
    } else {
        if (report[1] > report[2]) {
            direction = Direction.decrease;
        } else {
            direction = Direction.increase;
        }
    }
    var offense_index: usize = 0;
    var retry = false;
    for (0..report.len) |r| {
        print("report: {}\n", .{report[r]});
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
                print("should go in here! {}\n", .{r});
                offense_detected = true;
            }
            if (r > 0 and offense_detected == false) {
                const diff = current - previous;
                if (isCausingAnOffense(diff, direction)) {
                    one_not_offensive = false;
                    break;
                }
            }
            if (offense_detected == false) {
                previous = current;
            }
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
            if (offense_detected == false) {
                previous = current;
            }
        }
        for (0..report.len) |r| {
            var offense_detected: bool = false;
            const current: i32 = report[r];
            if (current == 170) break;
            if (r == (offense_index - 1)) {
                offense_detected = true;
                print("offense_detected: {}\n", .{r});
            }
            if (r > 0 and offense_detected == false) {
                var diff = current - previous;
                if (diff > 0 and direction == Direction.decrease) {
                    diff = -diff;
                }
                if (isCausingAnOffense(diff, direction)) {
                    print("should not go in here! {}\n", .{current});
                    print("previous silly bugger: {}\n", .{previous});
                    print("direction: {}\n", .{direction});
                    print("diff: {}\n", .{diff});
                    print("shouldn't in here!\n", .{});
                    three_not_offensive = false;
                    break;
                }
            }
            if (offense_detected == false) {
                previous = current;
            }
        }
        print("One not offense: {}\n", .{(one_not_offensive or two_not_offensive or three_not_offensive)});
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

    // var safe: u32 = 0;
    // for (0..reports.len) |r| {
    //     if (isSafe(&reports[r])) {
    //         safe += 1;
    //     }
    // }

    // print("safe: {} \n", .{safe});

    var almost_safe: u32 = 0;
    for (0..reports.len) |r| {
        if (isAlmostSafe(&reports[r])) {
            almost_safe += 1;
        }
        // if (r == 1) {
        //     // print("isSafe: {}\n", .{isSafe(&reports[r])});
        //     print("isAlmostSafe: {}\n", .{isAlmostSafe(&reports[r])});
        //     break;
        // }
    }

    print("almost safe: {}\n", .{almost_safe});
}
