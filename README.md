# TraceCore-16

A 16-bit, 3-stage pipelined CPU with a built-in **observability subsystem**: a hardware trace buffer, performance counters, and a control-flow-integrity (CFI) anomaly detector. The core can watch its own execution and expose that state without halting.

Written in SystemVerilog, simulated with Icarus Verilog, and planned for RTL-to-GDS2 through OpenLane (Sky130).

## Status

| Block | File | Status |
|---|---|---|
| Instruction memory | `imem.sv` | Done, tested |
| Data memory | `dmem.sv` | Done, tested |
| Register file | `regfile.sv` | Done, tested |
| ALU | `alu.sv` | Done, tested |
| Decoder | `decoder.sv` | Planned |
| Pipeline core | `core.sv` | Planned |
| Trace buffer | | Planned |
| Performance counters | | Planned |
| Anomaly / CFI unit | | Planned |
| Debug access port (MMIO) | | Planned |

## Why this project

Most small student CPUs execute instructions and expose nothing about their own behavior. TraceCore borrows ideas from ARM CoreSight, RISC-V trace, and hardware performance monitors, and from Intel CET's shadow stack for control-flow integrity. It scales them down to something one person can take from RTL through GDS2.

## Architecture

```
Fetch (imem) --> Decode/Execute (decoder, regfile, alu) --> Writeback (dmem + regfile write)
                                  |
                                  v
                   Observability subsystem (planned)
                   trace buffer | perf counters | anomaly unit
                                  |
                                  v
                       Debug access port (MMIO)
```

- **Word size:** 16 bits
- **Registers:** R0 to R7 (R7 is the link register by convention)
- **Memory:** Harvard, word-addressed, 256 words each for instruction and data in v1
- **Pipeline:** 3 stages (Fetch, Decode/Execute, Writeback)

### Design notes

- **Register hazards:** no stall needed at this depth. The register file's write-through bypass covers same-cycle producer/consumer cases.
- **Memory hazard:** a STORE immediately followed by a LOAD to the same address needs an explicit store-to-load forward, since the data memory write lands one cycle after the read.
- **Control hazards:** no branch prediction. A taken branch or jump squashes the speculatively fetched instruction and redirects the PC (one bubble cycle).

## Instruction set

All instructions are 16 bits wide.

```
R-type: [15:12] opcode | [11:9] rd  | [8:6] rs1 | [5:3] rs2 | [2:0] funct3
I-type: [15:12] opcode | [11:9] rd  | [8:6] rs1 | [5:0] imm6
B-type: [15:12] opcode | [11:9] rs1 | [8:6] rs2 | [5:0] offset6
J-type: [15:12] opcode | [11:0] offset12
```

| Opcode | Mnemonic | Description |
|---|---|---|
| 0000 | ADD / SUB / AND / OR / XOR / SLT | R-type, selected by `funct3` (000 to 101) |
| 0001 | ADDI | `rd = rs1 + imm6` |
| 0010 | LOAD | `rd = MEM[rs1 + imm6]` |
| 0011 | STORE | `MEM[rs1 + imm6] = rd` (rd field holds the source register) |
| 0100 | BEQ | branch if `rs1 == rs2` |
| 0101 | BNE | branch if `rs1 != rs2` |
| 0110 | JAL | `R7 = PC+1; PC += offset12` |
| 0111 | JALR | `R7 = PC+1; PC = rs1 + imm6` |
| 1000 | LUI | `rd = {imm6, 10'b0}` |
| 1110 | NOP | no operation |
| 1111 | HALT | stop execution |

Opcodes 1001 to 1101 are reserved.

## Planned observability subsystem

Memory-mapped registers in `0xFF00` to `0xFFFF`:

- **Trace buffer:** circular log of recently retired instructions (PC, instruction, register write, branch outcome)
- **Performance counters:** cycles, retired instructions, branches, mispredicts, stalls
- **Anomaly unit:** illegal-opcode trap and a shadow-stack return-address check for CFI
- **Debug access port:** reads all of the above while the core keeps running

## Repository layout

```
rtl/        SystemVerilog design files (imem, dmem, regfile, alu, ...)
tb/         Testbenches
sw/         Python assembler and trace viewer (planned)
docs/       Architecture notes and diagrams
```

## Running the tests

Requires [Icarus Verilog](https://github.com/steveicarus/iverilog).

```bash
iverilog -g2012 -o sim imem.sv  tb_imem.sv   && vvp sim
iverilog -g2012 -o sim dmem.sv  tb_dmem.sv   && vvp sim
iverilog -g2012 -o sim regfile.sv tb_regfile.sv && vvp sim
iverilog -g2012 -o sim alu.sv   tb_alu.sv    && vvp sim
```

Each testbench prints PASS or FAIL for its checks.

## Roadmap

1. Pipeline: decoder and 3-stage core wiring the blocks together
2. Observability subsystem: trace buffer, counters, anomaly unit, debug port
3. Full-core verification, including observability-specific tests
4. Python assembler and demo programs
5. Trace viewer tool
6. RTL-to-GDS2 with OpenLane, with STA, power, and area reports
7. Documentation, diagrams, and demo

## Tools

SystemVerilog, Icarus Verilog, GTKWave, OpenLane (Yosys, OpenROAD, Magic, KLayout), Sky130 PDK, Python.
