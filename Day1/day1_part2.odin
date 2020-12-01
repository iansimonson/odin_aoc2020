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

    data := make([dynamic]int, 0, 1000);
    defer delete(data);

    for line in lines {
        value, ok := strconv.parse_int(line);
        if !ok {
            return;
        }

        append(&data, value);
    }

    sort.slice(data[:]);

    for outer_begin in 0..<len(data) - 2 {
        value_to_find := 2020 - data[outer_begin];
        begin := outer_begin + 1;
        end := len(data) - 1;
        for begin < end {
            cur_value := data[begin] + data[end];
            if cur_value < value_to_find {
                begin += 1;
            } else if cur_value > value_to_find {
                end -= 1;
            } else {
                fmt.println(data[outer_begin] * data[begin] * data[end]);
                return;
            }
        }
    }

    fmt.println("Found nothing");
}