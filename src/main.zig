const std = @import("std");

const flags = @import("flags");

pub fn main() !void {
    _ = try flags.parse();
    const name = flags.string("name", "joe", "A name of the user");
    std.debug.print("-> Name: {s}\n", .{name});
}
