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
    var maxSubArray: [2]usize = .{ 0, 0};
    var maxSum: [1]i32 = .{0};
    _ = try split(arr.items, 0, arr.items.len - 1, &maxSubArray, &maxSum);
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "arr: {d}\n", .{arr.items}));
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray: {d}\n", .{maxSubArray}));
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray values: {d}, {d}\n", .{arr.items[maxSubArray[0]], arr.items[maxSubArray[1]]}));
}

fn split(arr: []const i32, start: usize, end: usize, maxSubArray: []usize, maxSum: []i32) !void {
    if (end - start <= 1) {
        return;
    }
    const mid = (end + start) / 2;
    _ = try split(arr, start, mid-1, maxSubArray, maxSum);
    _ = try split(arr, mid, end, maxSubArray, maxSum);
    _ = try merge(arr, start, mid, end, maxSubArray, maxSum);
}

fn merge(arr: []const i32, start: usize, mid: usize, end: usize, maxSubArray: []usize, maxSum: []i32) !void {
    // print("{d}, {d}\n", .{ arr[start..mid], arr[mid .. end + 1] });
    
    var aIndex: usize = start;
    var aSum: i32 = 0;
    var aSubArray: [2]usize = .{start, start};
    
    var bIndex: usize = mid;
    var bSum: i32 = 0;
    var bSubArray: [2]usize = .{mid, mid};

    var tempSum: i32 = 0;
    var lastRestart: usize = aIndex;
    while (aIndex < mid) : (aIndex += 1) {
        tempSum += arr[aIndex];
        if (tempSum > aSum) {
            aSubArray[0] = lastRestart;
            aSubArray[1] = aIndex;
            aSum = tempSum;
        }
        if (tempSum < 0) {
            tempSum = 0; 
            lastRestart = aIndex + 1;
        }
    }

    tempSum = 0;
    lastRestart = bIndex;
    while (bIndex < end + 1) : (bIndex += 1) {
        tempSum += arr[bIndex];
        if (tempSum > bSum) {
            bSubArray[0] = lastRestart;
            bSubArray[1] = bIndex;
            bSum = tempSum;
        }
        if (tempSum < 0) {
            tempSum = 0; 
            lastRestart = bIndex + 1;
        }
    }

    var tSum: i32 = 0;
    var tSubArray: [2]usize = .{0, 0};
    if (aSubArray[1] == mid-1 and bSubArray[0] == mid) {
        tSum = aSum + bSum;
        tSubArray[0] = aSubArray[0];
        tSubArray[1] = bSubArray[1];
    }

    // print("tSum: {d}, aSum: {d}, bSum: {d}, maxSum[0] {d}\n", .{tSum, aSum, bSum, maxSum[0]});
    if (tSum > aSum and tSum > bSum and tSum > maxSum[0]) {
        maxSubArray[0] = tSubArray[0];
        maxSubArray[1] = tSubArray[1];
        maxSum[0] = tSum;
    }

    else if (aSum > bSum and aSum > maxSum[0]) {
        maxSubArray[0] = aSubArray[0];
        maxSubArray[1] = aSubArray[1];
        maxSum[0] = aSum;
    }

    else if (bSum > aSum and bSum > maxSum[0]) {
        maxSubArray[0] = bSubArray[0];
        maxSubArray[1] = bSubArray[1];
        maxSum[0] = bSum;
    }
}
