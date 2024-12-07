const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

const State = enum { X, M, A, S, none };

const Vector = struct {
    x: u64,
    y: u64,
};

fn parseCharacter(character: u8, current_state: State) State {
    const state: State = switch (character) {
        'X' => State.X,
        'M' => {
            if (current_state == State.X) {
                return State.M;
            } else {
                return State.none;
            }
        },
        'A' => {
            if (current_state == State.M) {
                return State.A;
            } else {
                return State.none;
            }
        },
        'S' => {
            if (current_state == State.A) {
                return State.S;
            } else {
                return State.none;
            }
        },
        else => State.none,
    };
    return state;
}

fn search(wordsearch: [140][]const u8, position: Vector) u64 {
    var found: u64 = 0;
    const lowest_pos: u8 = 3;
    const highest_pos: u8 = 136;

    print("vector: {}, {}\n", .{ position.x, position.y });
    //right
    var char_state: State = State.none;
    if (position.x <= highest_pos) {
        print("less than highest x\n", .{});
        for (0..4) |i| {
            print("loops!\n", .{});
            char_state = parseCharacter(wordsearch[position.y][position.x + i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        print("Char state S\n", .{});
        found += 1;
    }

    //left
    char_state = State.none;
    if (position.x >= lowest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y][position.x - i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //up
    char_state = State.none;
    if (position.y >= lowest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y - i][position.x], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //down
    char_state = State.none;
    if (position.y <= highest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y + i][position.x], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //up left
    char_state = State.none;
    if (position.y >= lowest_pos and position.x >= lowest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y - i][position.x - i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //up right
    char_state = State.none;
    if (position.y >= lowest_pos and position.x <= highest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y - i][position.x + i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //down left
    char_state = State.none;
    if (position.y <= highest_pos and position.x >= lowest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y + i][position.x - i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }

    //down right
    char_state = State.none;
    if (position.y <= highest_pos and position.x <= highest_pos) {
        for (0..4) |i| {
            char_state = parseCharacter(wordsearch[position.y + i][position.x + i], char_state);
            if (char_state == State.none) {
                break;
            }
        }
    }
    if (char_state == State.S) {
        found += 1;
    }
    return found;
}

pub fn main() !void {
    var wordsearch = splitAny(u8, data, "\n");
    var parsed_wordsearch: [140][]const u8 = undefined;
    var total: u64 = 0;
    var index: u64 = 0;
    while (wordsearch.next()) |r| {
        if (index == 140) break;
        parsed_wordsearch[index] = r;
        index += 1;
    }
    for (0..parsed_wordsearch.len) |i| {
        for (0..parsed_wordsearch[i].len) |c| {
            const char = parsed_wordsearch[i][c];
            if (char == 'X') {
                total += search(parsed_wordsearch, Vector{ .x = c, .y = i });
            }
        }
    }

    print("total: {}\n", .{total});
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
