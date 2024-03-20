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
    var maxSubArray: [2]usize = .{ 0, 0 };
    maxSubArray = maxSubArray;
    _ = try split(arr.items, 0, arr.items.len - 1, &maxSubArray);
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "arr: {d}\n", .{arr.items}));
    _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray: {d}\n", .{maxSubArray}));
    _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray values: {d}, {d}\n", .{arr.items[maxSubArray[0]], arr.items[maxSubArray[1]]}));
}

fn split(arr: []const i32, start: usize, end: usize, maxSubArray: []usize) !void {
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

fn merge(arr: []const i32, start: usize, mid: usize, end: usize, maxSubArray: []usize) !void {
    print("{d}, {d}\n", .{ arr[start..mid], arr[mid .. end + 1] });
    
    const maxDiff: i32 = arr[maxSubArray[1]] - arr[maxSubArray[0]];
    var aIndex: usize = start;
    var bIndex: usize = mid;
    var aMinIndex: usize = start;
    var bMaxIndex: usize = mid;
    while (aIndex < mid) : (aIndex += 1) {
        if (arr[aIndex] < arr[aMinIndex]) {
            aMinIndex = aIndex;
        }
    }
    while (bIndex <= end) : (bIndex += 1) {
        if (arr[bIndex] > arr[bMaxIndex]) {
            bMaxIndex = bIndex;
        }
    }
    const tSubArray: [2]usize = .{aMinIndex, bMaxIndex};
    const tMaxDiff: i32 = arr[bMaxIndex] - arr[aMinIndex];
    print("tMaxDiff: {d}\n", .{tMaxDiff});
    if (tMaxDiff > maxDiff) {
        maxSubArray[0] = tSubArray[0];
        maxSubArray[1] = tSubArray[1];
    }

    // print("aMaxDiff: {d}\n", .{ aMaxDiff });
    // print("bMaxDiff: {d}\n", .{ bMaxDiff });
    // print("aSubArray: {d}\n", .{aSubArray});
    print("tSubArray: {any}\n", .{tSubArray});
    print("maxDiff: {any}\n", .{maxDiff});
    print("maxSubArray: {any}\n", .{maxSubArray});
}
