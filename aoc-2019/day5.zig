
const std = @import("std");
const direct_allocator = std.heap.direct_allocator;
const separate = std.mem.separate;
const parseInt = std.fmt.parseInt;
const readLine = std.io.readLine;
const warn = std.debug.warn;
const pow = std.math.pow;
const ArrayList = std.ArrayList;
const Buffer = std.Buffer;

const input = "3,225,1,225,6,6,1100,1,238,225,104,0,1001,210,88,224,101,-143,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,101,42,92,224,101,-78,224,224,4,224,1002,223,8,223,1001,224,3,224,1,223,224,223,1101,73,10,225,1102,38,21,225,1102,62,32,225,1,218,61,224,1001,224,-132,224,4,224,102,8,223,223,1001,224,5,224,1,224,223,223,1102,19,36,225,102,79,65,224,101,-4898,224,224,4,224,102,8,223,223,101,4,224,224,1,224,223,223,1101,66,56,224,1001,224,-122,224,4,224,102,8,223,223,1001,224,2,224,1,224,223,223,1002,58,82,224,101,-820,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,2,206,214,224,1001,224,-648,224,4,224,102,8,223,223,101,3,224,224,1,223,224,223,1102,76,56,224,1001,224,-4256,224,4,224,102,8,223,223,1001,224,6,224,1,223,224,223,1102,37,8,225,1101,82,55,225,1102,76,81,225,1101,10,94,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,8,226,677,224,102,2,223,223,1005,224,329,101,1,223,223,1008,677,677,224,1002,223,2,223,1006,224,344,1001,223,1,223,107,226,677,224,102,2,223,223,1005,224,359,1001,223,1,223,1108,677,677,224,1002,223,2,223,1006,224,374,101,1,223,223,1107,677,677,224,1002,223,2,223,1006,224,389,101,1,223,223,108,226,677,224,102,2,223,223,1006,224,404,101,1,223,223,7,677,677,224,102,2,223,223,1006,224,419,101,1,223,223,108,677,677,224,102,2,223,223,1006,224,434,1001,223,1,223,7,226,677,224,102,2,223,223,1006,224,449,1001,223,1,223,108,226,226,224,102,2,223,223,1005,224,464,101,1,223,223,8,226,226,224,1002,223,2,223,1006,224,479,101,1,223,223,1008,226,226,224,102,2,223,223,1005,224,494,1001,223,1,223,1008,677,226,224,1002,223,2,223,1005,224,509,101,1,223,223,7,677,226,224,102,2,223,223,1006,224,524,101,1,223,223,1007,677,226,224,1002,223,2,223,1006,224,539,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,554,1001,223,1,223,8,677,226,224,1002,223,2,223,1005,224,569,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,584,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,599,101,1,223,223,107,226,226,224,102,2,223,223,1006,224,614,1001,223,1,223,107,677,677,224,1002,223,2,223,1005,224,629,1001,223,1,223,1107,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1007,677,677,224,102,2,223,223,1006,224,659,1001,223,1,223,1007,226,226,224,1002,223,2,223,1006,224,674,1001,223,1,223,4,223,99,226";

pub fn main() !void {
    var memory = ArrayList(i32).init(direct_allocator);
    defer memory.deinit();

    // Parse the input into an array of instructions
    {
        var it = separate(input, ",");
        while (it.next()) |str|
            try memory.append(try parseInt(i32, str, 10));
    }

    // Initialize input buffer
    var buffer = try Buffer.initSize(direct_allocator, 0);
    defer buffer.deinit();

    // Execute the program.
    try execute(memory.toSlice(), &buffer);
}

var input_buffer: Buffer;

fn execute(mem: []i32, input_buf: *Buffer) !void {
    // Instruction pointer
    var ip: u32 = 0;
    while (true) {
        // Determine the opcode and parameter modes
        const head = @intCast(u32, mem[ip]);
        const op = head % 100;
        const mode_1 = head / 100 % 10;
        const mode_2 = head / 1000 % 10;

        switch (op) {
            // Add
            1 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                mem[@intCast(usize, mem[ip + 3])] = par_1 + par_2;
                ip += 4;
            },

            // Multiply
            2 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                mem[@intCast(usize, mem[ip + 3])] = par_1 * par_2;
                ip += 4;
            },

            // Store input value from stdin
            3 => {
                warn("(input): ", .{});
                mem[@intCast(usize, mem[ip + 1])] = try parseInt(i32, try readLine(input_buf), 10);
                ip += 2;
            },

            // Print output value
            4 => {
                const val = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                warn("{}\n", .{val});
                ip += 2;
            },

            // Jump if true
            5 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                ip = if (par_1 != 0) @intCast(u32, par_2) else ip + 3;
            },

            // Jump if false
            6 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                ip = if (par_1 == 0) @intCast(u32, par_2) else ip + 3;
            },

            // Less than
            7 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                mem[@intCast(usize, mem[ip + 3])] = if (par_1 < par_2) 1 else 0;
                ip += 4;
            },

            // Equal to
            8 => {
                const par_1 = if (mode_1 == 1) mem[ip + 1] else mem[@intCast(usize, mem[ip + 1])];
                const par_2 = if (mode_2 == 1) mem[ip + 2] else mem[@intCast(usize, mem[ip + 2])];

                mem[@intCast(usize, mem[ip + 3])] = if (par_1 == par_2) 1 else 0;
                ip += 4;
            },

            // Halt
            99 => return,

            else => unreachable,
        }
    }
}
