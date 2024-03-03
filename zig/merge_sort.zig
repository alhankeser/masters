const std = @import("std");
const print = std.debug.print;

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

    var arr1 = std.ArrayList(u32).init(allocator);
    defer arr1.deinit();
    var arr2 = std.ArrayList(u32).init(allocator);
    defer arr2.deinit();

    while (iterator.next()) |raw| {
        const n: u32 = try std.fmt.parseInt(u32, raw, 10);
        if (@TypeOf(n) == u32) {
            try arr1.append(n);
            try arr2.append(n);
        }
    }

    // print("IN: {d}\n", .{arr1.items});
    mergeSort(arr1.items, arr2.items, 0, arr2.items.len);
    _ = arr1.items;
    // print("OUT: {d}\n", .{arr1.items});
    // return arr1.items;
}

fn mergeSort(arr1Items: []u32, arr2Items: []u32, start: usize, end: usize, ) void {
    if (end - start <= 1) {
        return;
    }
    const midpoint = (end + start) / 2;
    mergeSort(arr2Items, arr1Items, start, midpoint);
    mergeSort(arr2Items, arr1Items, midpoint, end);
    mergeArrays(arr2Items, arr1Items, start, midpoint, end);
}

fn mergeArrays(arr1Items: []u32,  arr2Items: []u32, start: usize, midpoint: usize, end: usize,) void {
    var i = start;
    var k = start;
    var j = midpoint;

    while (k < end) : (k += 1) { 
        if (i < midpoint and (j >= end or arr1Items[i] <= arr1Items[j])) {
            arr2Items[k] = arr1Items[i];
            i = i + 1;
        } else {
            arr2Items[k] = arr1Items[j];
            j = j + 1;
        }
    }
    // print("out local: {d}\n", .{arr2Items[start..end]});
}