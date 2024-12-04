const std = @import("std");
const data = @embedFile("data/day03.txt");
const indexOfAny = std.mem.indexOfAny;
const trim = std.mem.trim;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;

const State: type = enum {
    m,
    u,
    l,
    par_open,
    n1_start,
    n1_continued,
    n1_end,
    n2_start,
    n2_continued,
    n2_end,
    none,
    d,
    o,
    n,
    s_quote,
    t,
    open_par_do,
    close_par_do,
    open_par_dont,
    close_par_dont,
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
        '(' => {
            if (current_state == State.l) {
                return State.par_open;
            }
            if (current_state == State.o) {
                return State.open_par_do;
            } else if (current_state == State.t) {
                return State.open_par_dont;
            } else {
                return State.none;
            }
        },
        ')' => {
            if (current_state == State.n2_continued or current_state == State.n2_start) {
                return State.n2_end;
            } else if (current_state == State.open_par_do) {
                return State.close_par_do;
            } else if (current_state == State.open_par_dont) {
                return State.close_par_dont;
            } else {
                return State.none;
            }
        },
        48...57 => {
            if (current_state == State.par_open) {
                return State.n1_start;
            } else if (current_state == State.n1_start) {
                return State.n1_continued;
            } else if (current_state == State.n1_continued) {
                return State.n1_continued;
            } else if (current_state == State.n1_end) {
                return State.n2_start;
            } else if (current_state == State.n2_start) {
                return State.n2_continued;
            } else if (current_state == State.n2_continued) {
                return State.n2_continued;
            } else {
                return State.none;
            }
        },
        ',' => {
            if (current_state == State.n1_continued or current_state == State.n1_start) {
                return State.n1_end;
            } else {
                return State.none;
            }
        },
        'd' => State.d,
        'o' => {
            if (current_state == State.d) {
                return State.o;
            } else {
                return State.none;
            }
        },
        'n' => {
            if (current_state == State.o) {
                return State.n;
            } else {
                return State.none;
            }
        },
        '\'' => {
            if (current_state == State.n) {
                return State.s_quote;
            } else {
                return State.none;
            }
        },
        't' => {
            if (current_state == State.s_quote) {
                return State.t;
            } else {
                return State.none;
            }
        },
        else => State.none,
    };
    return state;
}

fn parseAndMultiply(action: []const u8) !i64 {
    const trimmed_action = trim(u8, action, "mul");
    const index_of_comma: usize = indexOfAny(u8, trimmed_action, ",").?;
    const index_of_close_par: usize = indexOfAny(u8, trimmed_action, ")").?;
    const number_1_str: []const u8 = trim(u8, trimmed_action[1..(index_of_comma)], " ");
    const number_1_int: i64 = try parseInt(i64, number_1_str, 10);
    const number_2_str: []const u8 = trim(u8, trimmed_action[(index_of_comma + 1)..(index_of_close_par)], " ");
    const number_2_int: i64 = try parseInt(i64, number_2_str, 10);
    const total: i64 = (number_1_int * number_2_int);
    return total;
}

pub fn main() !void {
    const memory = data;
    var character_state: State = State.none;
    var total: i64 = 0;
    var enabled: bool = true;
    var start_index: ?usize = undefined;
    var end_index: ?usize = undefined;
    for (0..memory.len) |s| {
        character_state = parseCharacter(memory[s], character_state);
        if (character_state == State.close_par_do) {
            enabled = true;
        }
        if (character_state == State.close_par_dont) {
            enabled = false;
        }
        if (character_state == State.m) {
            start_index = s;
        } else if (character_state == State.none) {
            start_index = null;
        }
        if (character_state == State.n2_end) {
            end_index = s;
        } else if (character_state == State.none) {
            end_index = null;
        }
        if (start_index != null and end_index != null) {
            const i_start: usize = start_index.?;
            const i_end: usize = (end_index.? + 1);
            start_index = null;
            end_index = null;
            if (enabled == true) {
                total += try parseAndMultiply(memory[i_start..i_end]);
            }
        }
    }
    print("total: {}\n", .{total});
}
