const std = @import("std");
const direct_allocator = std.heap.direct_allocator;
const separate = std.mem.separate;
const parseInt = std.fmt.parseInt;
const warn = std.debug.warn;
const ArrayList = std.ArrayList;
const copy = std.mem.copy;

// Assume the input program is correct
const input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,9,1,19,1,9,19,23,1,23,5,27,2,27,10,31,1,6,31,35,1,6,35,39,2,9,39,43,1,6,43,47,1,47,5,51,1,51,13,55,1,55,13,59,1,59,5,63,2,63,6,67,1,5,67,71,1,71,13,75,1,10,75,79,2,79,6,83,2,9,83,87,1,5,87,91,1,91,5,95,2,9,95,99,1,6,99,103,1,9,103,107,2,9,107,111,1,111,6,115,2,9,115,119,1,119,6,123,1,123,9,127,2,127,13,131,1,131,9,135,1,10,135,139,2,139,10,143,1,143,5,147,2,147,6,151,1,151,5,155,1,2,155,159,1,6,159,0,99,2,0,14,0";

pub fn main() !void {
    var vec = ArrayList(u32).init(direct_allocator);
    defer vec.deinit();

    // Parse the input into an array of opcodes.
    {
        var it = separate(input, ",");
        while (it.next()) |str|
            try vec.append(try parseInt(u32, str, 10));
    }

    // Set the initial program state as specified
    vec.toSlice()[1] = 12;
    vec.toSlice()[2] = 2;

    const orig = vec.toSliceConst();

    // Create scratch memory we can restore after each execution
    const scratch = try direct_allocator.alloc(u32, orig.len);
    defer direct_allocator.free(scratch);

    copy(u32, scratch, orig);
    warn("The solution for part 1 is {}\n", .{execute(scratch)});

    var noun: u32 = 0;
    while (noun <= 99) : (noun += 1) {
        var verb: u32 = 0;
        while (verb <= 99) : (verb += 1) {
            copy(u32, scratch, orig); // Clear memory from the previous attempt
            scratch[1] = noun;
            scratch[2] = verb;
            if (execute(scratch) == 19690720) {
                warn("The solution for part 2 is {}{}\n", .{noun, verb});
                return;
            }
        }
    }
    warn("Could not find solution for part 2 :(\n", .{});
}

/// Returns the value at address 0 after the program halts
fn execute(mem: []u32) u32 {
    var ip: u32 = 0; // Instruction pointer
    while (true) {
        switch (mem[ip]) {
            // Add instruction
            1 => {
                mem[mem[ip + 3]] = mem[mem[ip + 1]] + mem[mem[ip + 2]];
                ip += 4;
            },

            // Muliply instruction
            2 => {
                mem[mem[ip + 3]] = mem[mem[ip + 1]] * mem[mem[ip + 2]];
                ip += 4;
            },

            // Halt instruction
            99 => return mem[0],

            // Unexpected
            else => unreachable,
        }
    }
}
