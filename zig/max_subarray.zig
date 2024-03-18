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
    var maxSubArray: [2]i32 = .{0,0};
    maxSubArray = maxSubArray;
    _ = try split(arr.items, 0, arr.items.len - 1,  &maxSubArray);
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "{any}\n", .{maxDiff}));
    _ = try stdout.write(try std.fmt.allocPrint(allocator, "{any}\n", .{maxSubArray}));
}

fn split(arr: []const i32, start: usize, end: usize, maxSubArray: []i32) ![]i32 {
    // print("{d}, {d}\n", .{start, end});
    // print("{any}\n", .{maxSubArray});
    if (end - start <= 1) {
        return maxSubArray;
    }
    const mid = (end + start) / 2;
    _ = try split(arr, start, mid, maxSubArray);
    _ = try split(arr, mid, end, maxSubArray);
    return merge(arr, start, mid, end, maxSubArray);
}

fn merge(arr: []const i32, start: usize, mid: usize, end: usize, maxSubArray: []i32) ![]i32 {
    print("{d}, {d}\n", .{arr[start..mid], arr[mid..end+1]});
    // var maxDiff = maxSubArray[1] - maxSubArray[0];
    var aIndex: usize = start;
    var bIndex: usize = mid+1;
    // A
    var aMin: i32 = arr[aIndex];
    var aMax: i32 = arr[aIndex];
    var bMin: i32 = arr[bIndex];
    var bMax: i32 = arr[bIndex];
    while (aIndex < mid - 1) : (aIndex += 1) {
        print("aIndex: {d}\n", .{arr[aIndex]});
        if (arr[aIndex] < aMin) {
            aMin = arr[aIndex];
        }
        if (arr[aIndex + 1] > aMax) {
            aMax = arr[aIndex + 1];
        }
    }
    while (bIndex < end) : (bIndex += 1) {
        print("bIndex: {d}\n", .{arr[bIndex]});
        if (arr[bIndex] < bMin) {
            bMin = arr[bIndex];
        }
        if (arr[bIndex + 1] > bMax) {
            bMax = arr[bIndex + 1];
        }
    }
    print("aMin: {d}, aMax: {d}\n", .{aMin, aMax});
    print("bMin: {d}, bMax: {d}\n", .{bMin, bMax});
    return maxSubArray;
}