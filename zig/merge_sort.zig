const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;

fn mergeArrays(arr1: []u32, arr2: []u32, allocator: std.mem.Allocator) ![]u32 {
    var result = std.ArrayList(u32).init(allocator);
    defer result.deinit();
    var i: u32 = 0;
    var j: u32 = 0;
    while (i < arr1.len and j < arr2.len) {
        // print("mergeArrays arr1: {d}\n", .{arr1});
        // print("mergeArrays arr2: {d}\n", .{arr2});
        if (i < arr1.len and arr1[i] <= arr2[j]) {
            try result.append(arr1[i]);
            i += 1;
        } else {
            try result.append(arr2[j]);
            j += 1;
        }
    }
    for (arr1[i..]) |a1| {
        try result.append(a1);
    }
    for (arr2[j..]) |a2| {
        try result.append(a2);
    }
    // print("mergeArrays result: {d}\n", .{result.items});
    return result.items[0..];
}

fn mergeSort(arr: []u32, allocator: std.mem.Allocator) ![]u32 {
    if (arr.len <= 1) {
        return arr;
    }
    const midpoint = arr.len / 2;
    print("{d}\n", .{arr});
    print("{d}\n", .{midpoint});
    const arr1 = try mergeSort(arr[0..midpoint], allocator);
    const arr2 = try mergeSort(arr[midpoint..], allocator);
    const result = try mergeArrays(arr1, arr2, allocator);
    // print("mergeSort result:{d}\n", .{result[0]});
    return result;
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

    var inputArray = std.ArrayList(u32).init(allocator);
    defer inputArray.deinit();

    while (iterator.next()) |raw| {
        const n: u32 = try std.fmt.parseInt(u32, raw, 10);

        if (@TypeOf(n) == u32) {
            try inputArray.append(n);
        } else {
            // print("Error\n", .{});
        }
    }

    const outputArray = try mergeSort(inputArray.items[0..], allocator);
    print("{d}\n", .{outputArray});
}
