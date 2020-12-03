package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import "core:sort"

main :: proc() {
    inputData, success := os.read_entire_file("input");
    if !success {
        return;
    }

    defer delete(inputData);
    lines := strings.split(string(inputData), "\n");
    defer delete(lines);

    map_data := make([dynamic][dynamic]bool, 0, 100);

    for line in lines {
        row := make([dynamic]bool, 0, len(line));
        for c in line {
            if c == '#' {
                append(&row, true);
            } else {
                append(&row, false);
            }
        }
        append(&map_data, row);
    }

    fmt.println(slope(&map_data, 1, 3));

    p2 := slope(&map_data, 1, 3)
        * slope(&map_data, 1, 1)
    * slope(&map_data, 1, 5)
    * slope(&map_data, 1, 7)
    * slope(&map_data, 2, 1);

    fmt.println(p2);
}

slope :: proc(data: ^$T, row_slope: int, col_slope: int) -> int {
    row := row_slope;
    col := col_slope;
    count := 0;

    for row < len(data) {
        if data[row][col] {
            count += 1;
        }
        
        col = (col + col_slope) % len(data[row]);
        row += row_slope;
    }

    return count;
}