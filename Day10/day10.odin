package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import "core:sort"
import "core:container"
import "core:math/bits"

main :: proc() {
    inputData, success := os.read_entire_file("input");
    if !success {
        return;
    }
    defer delete(inputData);

    lines := strings.split(string(inputData), "\n");
    defer delete(lines);

    numbers := make([dynamic]int);
    for line in lines {
        n, _ := strconv.parse_int(line);
        append(&numbers, n);
    }

    sort.slice(numbers[:]);

    p1 := part1(numbers[:]);
    p2 := part2(numbers[:]);
    fmt.println(p1);
    fmt.println(p2);
}

part1 :: proc(numbers: []int) -> int {
    one_count := 0;
    three_count := 1; // device is always one more

    prev_value := 0;
    for number in numbers {
        if number - prev_value == 1 {
            one_count += 1;
        } else if number - prev_value == 3 {
            three_count += 1;
        }

        prev_value = number;
    }

    return one_count * three_count;

}

part2 :: proc(numbers: []int) -> int {

    cache := make([dynamic]int, len(numbers));
    for i in 0..<len(cache) {
        cache[i] = -1;
    }
    defer delete(cache);
    sub_count :: proc(numbers: []int, n: int, cache: []int) -> int {
        if n == 0 { return 1; }
        else if n < 0 { return 0; }

        if cache[n] != -1 {
            return cache[n];
        }

        else {
            count := 0;
            for j := n - 1; j >= 0; j -= 1 {
                if numbers[n] - numbers[j] <= 3 {
                    count += sub_count(numbers, j, cache);
                }
            }
            if numbers[n] <= 3 {
                count += 1;
            }

            cache[n] = count;
            return count;
        }
    }
    
    count := sub_count(numbers, len(numbers) - 1, cache[:]);

    return count;
}