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
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray: {d}\n", .{maxSubArray}));
    // _ = try stdout.write(try std.fmt.allocPrint(allocator, "maxSubArray values: {d}, {d}\n", .{arr.items[maxSubArray[0]], arr.items[maxSubArray[1]]}));
}

fn split(arr: []const i32, start: usize, end: usize, maxSubArray: []usize) !void {
    // print("{d}, {d}\n", .{start, end});
    // print("{any}\n", .{maxSubArray});
    if (end - start <= 1) {
        return;
    }
    const mid = (end + start) / 2;
    _ = try split(arr, start, mid-1, maxSubArray);
    _ = try split(arr, mid, end, maxSubArray);
    _ = try merge(arr, start, mid, end, maxSubArray);
}

fn merge(arr: []const i32, start: usize, mid: usize, end: usize, maxSubArray: []usize) !void {
    // print("{d} to {d}\n", .{start, end});
    print("{d}, {d}\n", .{ arr[start..mid], arr[mid .. end + 1] });
    const maxSum: i32 = arr[maxSubArray[1]] + arr[maxSubArray[0]];
    var aIndex: usize = mid;
    var bIndex: usize = mid;
    var aSum: i32 = 0;
    var bSum: i32 = 0;
    var aMaxIndex: usize = start;
    var bMaxIndex: usize = mid;
    var tempSum: i32 =  0;
    // Go from right to left instead of left to right!!!
    while (aIndex >= start) : (aIndex += 1) {
        tempSum += arr[aIndex];
        if (tempSum > aSum) {
            aSum = tempSum;
            aMaxIndex = aIndex;
        }
        else {
            aMinIndex = aIndex;
        }
    }
    tempSum = 0;
    while (bIndex <= end) : (bIndex += 1) {
        tempSum += arr[bIndex];
        if (tempSum > bSum) {
            bSum = tempSum;
            bMaxIndex = bIndex;
        }
    }
    // print("{d}\n", .{bMaxIndex});
    if (aSum > bSum and aSum > (aSum + bSum) and aSum > maxSum) {
         maxSubArray[0] = start;
         maxSubArray[1] = aMaxIndex;
    }
    else if (bSum > aSum and bSum > (aSum + bSum) and bSum > maxSum) {
         maxSubArray[0] = mid;
         maxSubArray[1] = bMaxIndex;
    }
    else if ((aSum + bSum) > maxSum) {
         maxSubArray[0] = start;
         maxSubArray[1] = bMaxIndex;
    }
    print("aSum: {d}\n", .{aSum});
    print("bSum: {d}\n", .{bSum});
    print("maxSubArray: {d}\n", .{maxSubArray});
}
