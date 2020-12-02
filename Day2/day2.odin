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

    p1_count := part1(lines);
    p2_count := part2(lines);
 
    fmt.printf("part 1: {}\n", p1_count);
    fmt.printf("part 2: {}\n", p2_count);
}

both_parts_with_predicate :: proc(lines: []string, predicate: $F) -> int {
    count := 0;
    for line in lines {
        if (len(line) == 0) { continue; }

        fields := strings.split(line, " ");
        defer delete(fields);
        ranges := strings.split(fields[0], "-");
        defer delete(ranges);

        lower, ok_lower := strconv.parse_int(ranges[0]);
        higher, ok_higher := strconv.parse_int(ranges[1]);

        letter := fields[1];

        password := fields[2];

        if predicate(lower, higher, letter, password) {
            count += 1;
        }
    }
    return count;
}

part1 :: proc(lines: []string) -> int {
    p1_predicate :: proc(lower: int, higher: int, letter: string, password: string) -> bool {
        letter_count := strings.count(password, letter[0:1]);
        return letter_count >= lower && letter_count <= higher;
    }

    return both_parts_with_predicate(lines, p1_predicate);
}

part2 :: proc(lines: []string) -> int {
    p2_predicate :: proc(lower: int, higher: int, letter: string, password: string) -> bool {
        at_lower := password[lower - 1] == letter[0];
        at_higher := password[higher - 1] == letter[0];

        return at_lower ~ at_higher;
    }
    return both_parts_with_predicate(lines, p2_predicate);
}