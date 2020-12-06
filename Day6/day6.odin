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

    p1 := part1(string(inputData));
    p2 := part2(string(inputData));

    fmt.println(p1);
    fmt.println(p2);
}

part1 :: proc(inputData: string) -> int {
    lines := strings.split(inputData, "\n");
    defer delete(lines);

    count := 0;
    m := make(map[rune]int);
    defer delete(m);
    for line in lines {
        if len(line) == 0 {
            count += len(m);
            clear(&m);
            continue;
        }

        for c in line {
            m[c] = 0;
        }
    }

    return count;
}

part2 :: proc(inputData: string) -> int {
    lines := strings.split(inputData, "\n");
    defer delete(lines);

    count := 0;
    people_count := 0;
    m := make(map[rune]int);
    defer delete(m);
    for line in lines {
        if len(line) == 0 {
            sub_count := 0;
            for k, v in m {
                if v == people_count {
                    sub_count += 1;
                }
            }
            count += sub_count;
            clear(&m);
            people_count = 0;
            continue;
        }

        people_count += 1;

        for c in line {
            cur_val := m[c];
            m[c] = cur_val + 1;
        }
    }

    return count;
}