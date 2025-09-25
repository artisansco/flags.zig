const std = @import("std");

const Self = @This();

var entries: std.StringHashMap(union(enum) {
    flag: bool,
    str: []const u8,
}) = .init(std.heap.smp_allocator);

pub fn parse() !void {
    var args = std.process.args();
    defer args.deinit();
    _ = args.skip(); // skip the first argument (program name)

    while (args.next()) |arg| {
        const trimmed = std.mem.trimStart(u8, arg, "-"); // trim leading dashes

        if (std.mem.indexOfScalar(u8, trimmed, '=') != null) {
            var it = std.mem.splitScalar(u8, trimmed, '=');
            const key = it.first();
            const value = it.rest();
            try entries.put(key, .{ .str = value });
        } else {
            try entries.put(trimmed, .{ .flag = true });
        }
    }
}

pub fn string(name: []const u8, value: []const u8, description: []const u8) []const u8 {
    _ = description; // autofix
    if (entries.get(name)) |found| {
        switch (found) {
            .str => |v| return v,
            else => return value,
        }
    }

    return value;
}
