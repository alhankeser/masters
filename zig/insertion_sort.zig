const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

fn insertionSort(arr: std.ArrayList(u32)) void {
   var current_index: u32 = 1;
   while (current_index < arr.items.len) {
      const current_value: u32 = arr.items[current_index];
      var comparison_index: u32  = current_index - 1;
      while (comparison_index >= 0 and current_value < arr.items[comparison_index]) {
         arr.items[comparison_index + 1] = arr.items[comparison_index];
         arr.items[comparison_index] = current_value;
         if (comparison_index > 0) {
            comparison_index -= 1;
         }
      }
      current_index += 1;
   }
   // return arr;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filepath = args[1];
    const file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();

    const read_buf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(read_buf);

    var iterator = std.mem.split(u8, read_buf, "\n");

    var input_array = std.ArrayList(u32).init(allocator);
    defer input_array.deinit();

    while (iterator.next()) |raw| {
      const n: u32 = try std.fmt.parseInt(u32, raw, 10); 

      if (@TypeOf(n) == u32) {
         try input_array.append(n);
      }
      else {
         // print("Error\n", .{});
      }
    }
    
    insertionSort(input_array);
   //  print("{any}", .{input_array.items});
}
