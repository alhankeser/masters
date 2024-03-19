const std = @import("std");
const print = std.debug.print;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const filePath = args[1];
    const file = try std.fs.cwd().openFile(filePath, .{});
    defer file.close();

    // const rowCount = try std.fmt.parseInt(u32, args[2], 10);
    const rowCount = args[2];
    const maxBytes = try std.fmt.parseInt(u32, rowCount, 10) * (rowCount.len + 2);
    const readBuf = try file.readToEndAlloc(allocator, maxBytes);
    defer allocator.free(readBuf);

    var iterator = std.mem.split(u8, readBuf, "\n");

    var arr = std.ArrayList(i32).init(allocator);
    defer arr.deinit();

    while (iterator.next()) |raw| {
        const n: i32 = try std.fmt.parseInt(i32, raw, 10);
        if (@TypeOf(n) == i32) {
            try arr.append(n);
        }
    }
    var maxSubArray: [2]i32 = .{ 0, 0 };
    maxSubArray = maxSubArray;
    _ = try split(arr.items, 0, arr.items.len - 1, &maxSubArray);
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "{any}\n", .{maxDiff}));
    _ = try stdout.write(try std.fmt.allocPrint(allocator, "{any}\n", .{maxSubArray}));
}

fn split(arr: []const i32, start: usize, end: usize, maxSubArray: []i32) !void {
    // print("{d}, {d}\n", .{start, end});
    // print("{any}\n", .{maxSubArray});
    if (end - start <= 1) {
        return;
    }
    const mid = (end + start) / 2;
    _ = try split(arr, start, mid, maxSubArray);
    _ = try split(arr, mid, end, maxSubArray);
    _ = try merge(arr, start, mid, end, maxSubArray);
}

fn merge(arr: []const i32, start: usize, mid: usize, end: usize, maxSubArray: []i32) !void {
    print("{d}, {d}\n", .{ arr[start..mid], arr[mid .. end + 1] });
    // var maxDiff = maxSubArray[1] - maxSubArray[0];
    var aIndex: usize = start;
    var bIndex: usize = mid;
    // A
    var aMaxDiff: i32 = 0;
    var bMaxDiff: i32 = 0;
    var aSubArray: [2]usize = .{start, start};
    var bSubArray: [2]usize = .{mid, mid};
    while (aIndex < mid - 1) : (aIndex += 1) {
        var aCompare = aIndex + 1;
        while (aCompare < mid) : (aCompare += 1) {
            if ((arr[aCompare] - arr[aIndex]) > aMaxDiff) {
                aSubArray = .{aIndex, aCompare};
                aMaxDiff = arr[aCompare] - arr[aIndex];
            }
        }
    }
    while (bIndex < end - 1) : (bIndex += 1) {
        var bCompare = bIndex + 1;
        while (bCompare < end) : (bCompare += 1) {
            if ((arr[bCompare] - arr[bIndex]) > bMaxDiff) {
                bSubArray = .{bIndex, bCompare};
                bMaxDiff = arr[bCompare] - arr[bIndex];
            }
        }
    }
    print("aMaxDiff: {d}\n", .{ aMaxDiff });
    print("bMaxDiff: {d}\n", .{ bMaxDiff });
    print("aSubArray: {d}\n", .{aSubArray});
    print("bSubArray: {any}\n", .{bSubArray});
    print("maxSubArray: {any}\n", .{maxSubArray});
}
