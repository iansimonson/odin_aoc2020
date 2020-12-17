package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import "core:sort"
import "core:container"
import "core:math/bits"

Point4 :: distinct [4]int;


main :: proc() {
    inputData, success := os.read_entire_file("input");
    if !success {
        return;
    }
    defer delete(inputData);

    world := make(map[Point4]bool);
    defer delete(world);

    second_world := make(map[Point4]bool);
    defer delete(second_world);

    lines := strings.split(string(inputData), "\n");
    defer delete(lines);

    for line, i in lines {
        for cube, j in line {
            if cube == '#' {
                world[Point4{i, j, 0, 0}] = true;
            } else {
                world[Point4{i, j, 0, 0}] = false;
            }
        }
    }

    for i in 0..<6 {
        add_neighbors(&world);
        current_points := make([dynamic]Point4);
        defer delete(current_points);

        for k, _ in world {
            append(&current_points, k);
        }

        for k in current_points {
            v := world[k];
            active := active_neighbors(&world, k);
            if v && (active != 2 && active != 3) {
                second_world[k] = false;
            } else if !v && active == 3 {
                second_world[k] = true;
            } else {
                second_world[k] = v;
            }
        }
        clear(&world);
        for k, v in second_world {
            world[k] = v;
        }
        clear(&second_world);
    }

    sum := 0;
    for _, v in world {
        if v {
            sum += 1;
        }
    }

    fmt.println(sum);
}

add_neighbors :: proc(m: ^map[Point4]bool) {
    current_points := make([dynamic]Point4);
    defer delete(current_points);

    for k, _ in m {
        append(&current_points, k);
    }

    for v in current_points {
        for i in v.x - 1..v.x + 1 {
            for j in v.y - 1..v.y + 1 {
                for k in v.z - 1..v.z + 1 {
                    for a in v.w - 1..v.w + 1 {
                        key := Point4{i, j, k, a};
                        cur_val := m[key];
                        m[key] = cur_val;
                    }
                }
            }
        }
    }
}

active_neighbors :: proc(m: ^map[Point4]bool, p: Point4) -> int {
    active := 0;
    for i in p.x - 1..p.x + 1 {
        for j in p.y - 1..p.y + 1 {
            for k in p.z - 1..p.z + 1 {
                for a in p.w -1..p.w + 1 {
                    if (Point4{i, j, k, a} == p ){ continue; }
                    v := m[Point4{i, j, k, a}];
                    if v {
                        active += 1;
                    }
                }
            }
        }
    }
    return active;
}