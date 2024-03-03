const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;
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

    const readBuf = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(readBuf);

    var iterator = std.mem.split(u8, readBuf, "\n");

    var inArr = std.ArrayList(u32).init(allocator);
    defer inArr.deinit();
    var outArr = std.ArrayList(u32).init(allocator);
    defer outArr.deinit();

    while (iterator.next()) |raw| {
        const n: u32 = try std.fmt.parseInt(u32, raw, 10);
        if (@TypeOf(n) == u32) {
            try inArr.append(n);
            try outArr.append(n);
        }
    }

    print("IN: {d}\n", .{inArr.items});
    mergeSort(inArr.items, outArr.items, 0, outArr.items.len, );
    // print("IN: {d}\n", .{inArr.items});
    print("OUT: {d}\n", .{outArr.items});
}

fn mergeSort(inArrItems: []u32, outArrItems: []u32, start: usize, end: usize, ) void {
    if (end - start <= 1) {
        return;
    }
    const midpoint = (end + start) / 2;
    mergeSort(inArrItems, outArrItems, start, midpoint);
    mergeSort(inArrItems, outArrItems, midpoint, end);
    mergeArrays(inArrItems, outArrItems, start, midpoint, end);
}

fn mergeArrays(inArrItems: []u32,  outArrItems: []u32, start: usize, midpoint: usize, end: usize,) void {
    var i = start;
    var k = start;
    var j = midpoint;


    print("in local: {d}\n", .{inArrItems[start..end]});
    print("out local: {d}\n", .{outArrItems[start..end]});
    // print("i and k: {d}\n", .{k});
    // print("j: {d}\n", .{j});
    // print("start: {d}\n", .{start});
    // print("end: {d}\n", .{end});

    // print("while ({d} < {d}) : ({d} += 1)\n", .{k, end, k});

    while (k < end) : (k += 1) { 
    print("while ({d} < {d}) : ({d} += 1)\n\n", .{k, end, k});
    print("if ({d} < {d} and ({d} >= {d} or {d} <= {d})) \n\n", .{i, midpoint, j, end, inArrItems[i], inArrItems[j]});
        if (i < midpoint and (j >= end or inArrItems[i] <= inArrItems[j])) {
            print("set {d} to {d}\n\n", .{outArrItems[k], inArrItems[i]});
            outArrItems[k] = inArrItems[i];
            i = i + 1;
        } else {
            print("no: set {d} to {d}\n\n", .{outArrItems[k], inArrItems[j]});
            outArrItems[k] = inArrItems[j];
            j = j + 1;
        }
    }
}