const std = @import("std");
const data = @embedFile("data/day03.txt");

const State: type = enum {
    m,
    u,
    l,
    par_open,
    par_close,
    n1,
    n2,
    comma,
    none,
};

fn parseCharacter(character: u8, current_state: State) State {
    const state: State = switch (character) {
        'm' => State.m,
        'u' => {
            if (current_state == State.m) {
                return State.u;
            } else {
                return State.none;
            }
        },
        'l' => {
            if (current_state == State.u) {
                return State.l;
            } else {
                return State.none;
            }
        },
        else => State.none,
    };
    return state;
}

pub fn main() !void {
    const memory = "xxmuxul"; //"xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
    var character_state: State = State.none;
    for (0..memory.len) |s| {
        character_state = parseCharacter(memory[s], character_state);
    }
    if (character_state == State.l) {
        print("correct! \n", .{});
    } else {
        print("Incorrect! \n", .{});
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
