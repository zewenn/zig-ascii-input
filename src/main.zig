const std = @import("std");
const zinput = @import("./zig-input.zig").zinput;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var alloc = gpa.allocator();

    try zinput.init(&alloc);

    game_loop: while (true) {
        zinput.update();

        for (zinput.getKeys()) |key| {
            switch (key) {
                zinput.keys.ESCAPE => break :game_loop,
                zinput.keys.a => std.debug.print("xxxxx", .{}),
                zinput.keys.s => std.debug.print("ddddd", .{}),
                else => {}
            }
        }
    }

    zinput.deinit();
}
