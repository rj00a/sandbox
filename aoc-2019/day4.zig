
const std = @import("std");
const parseInt = std.fmt.parseInt;
const warn = std.debug.warn;
const pow = std.math.pow;

pub fn main() void {
    const lower_bound = 382345;
    const upper_bound = 843167;

    var count: u32 = 0;
    var curr: u32 = lower_bound;
    while (curr <= upper_bound) : (curr += 1) {
        if (has_two_adj(curr) and increasing(curr))
            count += 1;
    }
    warn("{}\n", .{count});
}

fn has_two_adj(v: u32) bool {
    var idx: u32 = 1;
    var count: u32 = 1;
    var last = v % 10;
    while (at(v, idx)) |curr| : (idx += 1) {
        if (curr == last) {
            count += 1;
        } else {
            if (count == 2)
                return true;
            last = curr;
            count = 1;
        }
    }
    return if (count == 2) true else false;
}

fn increasing(v: u32) bool {
    var idx: u32 = 1;
    var last = v % 10;
    while (at(v, idx)) |dig| : (idx += 1) {
        if (last < dig)
            return false;
        last = dig;
    }
    return true;
}

fn at(v: u32, idx: u32) ?u32 {
    const p = pow(u32, 10, idx);
    if (p > v and idx != 0)
        return null;
    return v / p % 10;
}
