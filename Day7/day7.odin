package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import "core:sort"
import "core:container"

main :: proc() {
    inputData, success := os.read_entire_file("input");
    if !success {
        return;
    }

    defer delete(inputData);

    m : map[string]map[string]int;

    rules := strings.split(string(inputData), "\n");
    for r in rules {
        if len(r) == 0 { continue; }
        // erase the period at the end of the rule
        rule := r[0:len(r) - 1];
        data := strings.split(rule, "contain");
        rule_key := strings.trim_space(data[0]);
        rule_key = rule_key[:len(rule_key) - 1]; // delete the plural 's'
        bag_map := m[rule_key];
        values := strings.split(data[1], ",");
        // fmt.printf("Values: {}\n", values);
        for value in values {
            trimmed := strings.trim_space(value);
            if len(trimmed) == 0 { continue; }
            else if trimmed == "no other bags" { continue; }

            if trimmed[len(trimmed) - 1] == 's' {
                trimmed = trimmed[:len(trimmed) - 1]; // remove the s so all keys are the same    
            }
            // fmt.printf("Adding to key {} the value {}\n", trimmed[2:], trimmed[0:1]);
            bag_map[trimmed[2:]], _ = strconv.parse_int(trimmed[0:1]);
        }
        // fmt.printf("Adding to rule key {} the map {}\n", rule_key, bag_map);
        m[rule_key] = bag_map;
    }

    p1 := part1(&m);
    p2 := part2(&m);

    fmt.println(p1);
    fmt.println(p2);
}

part1 :: proc(m: ^map[string]map[string]int) -> int {

    count := 0;

    visited_bags := make(map[string]int);
    defer delete(visited_bags);

    queue := container.Queue(string){};
    container.queue_init(&queue);
    defer container.queue_delete(queue);

    container.queue_push(&queue, string("shiny gold bag"));

    for {
        if container.queue_len(queue) == 0 {
            break;
        }

        bag_to_find := container.queue_pop_front(&queue);
        if bag_to_find in visited_bags {
            continue;
        }

        if len(bag_to_find) == 0 {
            continue;
        }

        visited_bags[bag_to_find] = 0;
        // fmt.printf("Looking at bag: {}\n", bag_to_find);
        for k, v in m^ {
            if (bag_to_find in v) && !(k in visited_bags) {
                // fmt.printf("Adding bag: {}\n", k);
                container.queue_push(&queue, strings.clone(k));
                // fmt.printf("Size of queue: {}\n", container.queue_len(queue));
                // fmt.printf("QueueDetails: {}", queue);
            }
        }

        // fmt.printf("Current_Visited: {}\n", visited_bags);
    }
    return len(visited_bags) - 1;
    
}

part2 :: proc(m: ^map[string]map[string]int) -> int {
    // Assuming no cycles going down because otherwise the laws of bag
    // physics would break
    dfs :: proc(m: ^map[string]map[string]int, bag_name: string) -> int {
        if len(m[bag_name]) == 0 {
            return 0;
        }

        count := 0;

        // fmt.printf("Bag {} contains the following:\n", bag_name);
        // fmt.printf("MAP: {}\n", m[bag_name]);
        for k, v in m[bag_name] {
            inner_count := dfs(m, k);
            // fmt.printf("inner_count={}, v={}\n", inner_count, v);
            count += (1 + inner_count) * v;
        }

        return count;
    }
    return dfs(m, string("shiny gold bag"));
}