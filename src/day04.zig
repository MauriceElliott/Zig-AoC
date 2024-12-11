const std = @import("std");
const splitAny = std.mem.splitAny;
const print = std.debug.print;
const data = @embedFile("data/day04.txt");
const State = enum { M, A, S, none };
const Vector = struct {
    x: u64,
    y: u64,
};

fn parseCharacter(character: u8, current_state: State) State {
    const state: State = switch (character) {
        'A' => State.A,
        'M' => {
            if (current_state == State.A) {
                return State.M;
            } else {
                return State.none;
            }
        },
        'S' => {
            if (current_state == State.M) {
                return State.S;
            } else {
                return State.none;
            }
        },
        else => State.none,
    };
    return state;
}

fn search(wordsearch: [140][]const u8, position: Vector) bool {
    var up_left: bool = false;
    var up_right: bool = false;
    var down_left: bool = false;
    var down_right: bool = false;

    //up left
    if (parseCharacter(wordsearch[position.y - 1][position.x - 1], State.A) == State.M) {
        if (parseCharacter(wordsearch[position.y + 1][position.x + 1], State.M) == State.S) {
            up_left = true;
        }
    }
    //up right
    if (parseCharacter(wordsearch[position.y - 1][position.x + 1], State.A) == State.M) {
        if (parseCharacter(wordsearch[position.y + 1][position.x - 1], State.M) == State.S) {
            up_right = true;
        }
    }
    //down left
    if (parseCharacter(wordsearch[position.y + 1][position.x - 1], State.A) == State.M) {
        if (parseCharacter(wordsearch[position.y - 1][position.x + 1], State.M) == State.S) {
            down_left = true;
        }
    }
    //down right
    if (parseCharacter(wordsearch[position.y + 1][position.x + 1], State.A) == State.M) {
        if (parseCharacter(wordsearch[position.y - 1][position.x - 1], State.M) == State.S) {
            down_right = true;
        }
    }
    return (up_left and up_right) or (up_right and down_right) or (down_right and down_left) or (up_left and down_left);
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
        if (i == 0) continue;
        if (i == 139) break;
        for (0..parsed_wordsearch[i].len) |c| {
            if (c == 0) continue;
            if (c == 139) break;
            const char = parsed_wordsearch[i][c];
            if (char == 'A') {
                if (search(parsed_wordsearch, Vector{ .x = c, .y = i })) {
                    total += 1;
                }
            }
        }
    }

    print("total: {}\n", .{total});
}
