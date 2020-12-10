package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:os"
import "core:sort"
import "core:container"

Instruction :: struct {
    instruction: proc(int, int, int)->(int,int),
    amount: int,
    visited: bool,
}

main :: proc() {
    inputData, success := os.read_entire_file("input");
    if !success {
        return;
    }
    defer delete(inputData);

    lines := strings.split(string(inputData), "\n");
    defer delete(lines);

    instructions := make([dynamic]Instruction);
    defer delete(instructions);

    for line in lines {
        if len(line) == 0 { continue; }

        inst := strings.split(line, " ");
        amt, _ :=  strconv.parse_int(inst[1]);
        // fmt.printf("Parsing instruction: Inst={}, Amt={}\n", inst[0], amt);
        if inst[0] == "jmp" {
            append(&instructions, Instruction{instruction = jmp, amount = amt, visited = false});
        } else if inst[0] == "acc" {
            append(&instructions, Instruction{instruction = acc, amount = amt, visited = false});
        } else if inst[0] == "nop" {
            append(&instructions, Instruction{instruction = nop, amount = amt, visited = false});
        }
    }

    p1 := part1(instructions[:]);
    p2 := part2(instructions[:]);

    fmt.println(p1);
    fmt.println(p2);

}

jmp :: proc(inst_counter: int, accumulator: int, amt: int) -> (new_inst: int, new_acc: int) {
    new_inst = inst_counter + amt;
    new_acc = accumulator;
    return;
}

acc :: proc(inst_counter: int, accumulator: int, amt: int) -> (new_inst: int, new_acc: int) {
    new_acc = accumulator + amt;
    new_inst = inst_counter + 1;
    return;
}

nop :: proc(inst_counter: int, accumulator: int, amt: int) -> (int, int) {
    return inst_counter + 1, accumulator;
}

part1 :: proc(instructions: []Instruction) -> int {
    acc := 0;
    inst_counter := 0;
    for {
        inst := instructions[inst_counter];
        // fmt.printf("INST: inst={}, counter={}, acc={}, visited={}\n", inst.instruction, inst_counter, acc, inst.visited);
        if instructions[inst_counter].visited {
            // fmt.println("Already visited, exiting");
            return acc;
        }
        
        instructions[inst_counter].visited = true;
        inst_counter, acc = instructions[inst_counter].instruction(inst_counter, acc, instructions[inst_counter].amount);
    }
    return acc;
}

part2 :: proc(instructions: []Instruction) -> int {
    test_code :: proc(instructions: []Instruction) -> (int, bool) {
        acc := 0;
        inst_counter := 0;
        for inst_counter < len(instructions) {
            if instructions[inst_counter].visited {
                return 0, false;
            }

            instructions[inst_counter].visited = true;
            inst_counter, acc = instructions[inst_counter].instruction(inst_counter, acc, instructions[inst_counter].amount);
        }

        return acc, true;
    }

    // first try nop -> jmp
    cur_offset := 0;
    for cur_offset < len(instructions) {
        if instructions[cur_offset].instruction == nop {
            instructions[cur_offset].instruction = jmp;
            acc, ok := test_code(instructions);
            if ok { return acc; }

            instructions[cur_offset].instruction = nop;
            for i in 0..<len(instructions) {
                instructions[i].visited = false;
            }
        }

        cur_offset += 1;
    }

    // now try jmp -> nop
    cur_offset = 0;
    for cur_offset < len(instructions) {
        if instructions[cur_offset].instruction == jmp {
            instructions[cur_offset].instruction = nop;
            acc, ok := test_code(instructions);
            if ok { return acc; }

            instructions[cur_offset].instruction = jmp;
            for i in 0..<len(instructions) {
                instructions[i].visited = false;
            }
        }

        cur_offset += 1;
    }

    return -1; // shouldn't happen
}