const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
   const filepath = "./inputs/c_compare_timing_input.txt";
   const file = try std.fs.cwd().openFile(filepath, .{});
   defer file.close();

//    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//    defer arena.deinit();
//    const allocator = arena.allocator();

//    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);

//    try std.io.getStdOut().writeAll(read_buf);
}
