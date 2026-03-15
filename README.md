# RISC-V 32-bit 5-Stage Pipelined Processor

![Full Pipeline Architecture](link_to_your_image_here.png)
*> Note: Replace `link_to_your_image_here.png` with the actual path or URL to your block diagram.*

This is a functional 32-bit RISC-V processor implementing a classic 5-stage pipeline. The design includes a hardware hazard detection unit, data forwarding, and branch resolution to efficiently execute a core subset of the RV32I instruction set.

---

## Pipeline Architecture

The processor uses five stages separated by pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) to pass data and control signals forward:

| Stage | Name | Core Operations |
| :---: | :--- | :--- |
| **IF** | **Instruction Fetch** | Fetches the 32-bit instruction from Instruction Memory using the PC. Calculates `PC + 4`. |
| **ID** | **Instruction Decode** | Decodes the instruction, extracts registers, reads data from the Register File, and generates control signals. |
| **EX** | **Execute** | ALU performs operations. Computes memory addresses for load/stores and resolves branch targets. |
| **MEM**| **Memory Access** | Reads from or writes to Data Memory. Non-memory instructions pass their ALU results through. |
| **WB** | **Write Back** | Writes the final result back into the destination register in the Register File. |

---

## Supported Instruction Set (RV32I)

The core implements key instructions from the standard RV32I base integer instruction set:

| Type | Instructions | Description |
| :--- | :--- | :--- |
| **R-Type** | `add`, `sub`, `and`, `or`, `xor`, `sll`, `srl`, `sra`, `slt`, `sltu` | Register-to-Register operations. |
| **I-Type** | `addi`, `andi`, `ori`, `xori`, `slli`, `srli`, `srai`, `slti`, `sltiu` | Immediate operations. |
| **Load/Store** | `lw`, `sw` | Word-level memory access. |
| **B-Type** | `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` | Conditional branches. |
| **J-Type** | `jal`, `jalr` | Unconditional jumps. |

---

## Hazard Detection & Resolution Logic

To handle instruction dependencies overlapping in the pipeline, this design uses a dedicated **Hazard Detection Unit** and **Forwarding Unit**.

### 1. Data Hazards (Read-After-Write)
Occurs when an instruction needs a value that a previous instruction hasn't written to the Register File yet.
* **Forwarding (Bypassing):** The Forwarding Unit intercepts data from the `EX/MEM` or `MEM/WB` registers and routes it directly to the ALU inputs in the `EX` stage. This handles `EX-to-EX` and `MEM-to-EX` dependencies without stalling.
* **Stalling (Load-Use Hazard):** If a `lw` instruction is immediately followed by an instruction that reads its target register, the data isn't ready until the `MEM` stage. The Hazard Detection Unit forces a **1-cycle stall** (inserts a NOP) and then forwards the data.

### 2. Control Hazards
Occurs during branch instructions. The next correct PC isn't known until the branch is evaluated in the `EX` stage, meaning wrong instructions may have entered `IF` and `ID`.
* **Flushing:** If a branch is taken, the Hazard Detection Unit asserts a flush signal. This clears the `IF/ID` and `ID/EX` pipeline registers (turning them into NOPs) and updates the PC to the correct target address.

---

## Memory & Register File

* **Register File:** 32 general-purpose registers (`x0` to `x31`), 32 bits wide. `x0` is hardwired to zero. It has two asynchronous read ports and one synchronous write port. It implements write-first logic for internal forwarding if a read and write happen on the same register in the same cycle.
* **Instruction Memory (IMEM):** Read-only memory storing machine code. Initialized via `.hex` files.
* **Data Memory (DMEM):** Read/Write memory for `lw` and `sw`.

---

## Repository Structure

```text
RISCV_5stage_pipeline/
├── rtl/                # Verilog source code for the processor
│   ├── alu.v           
│   ├── control.v       
│   ├── datapath.v      
│   ├── forwarding.v    
│   ├── hazard.v        
│   ├── regfile.v       
│   └── ...             
├── tb/                 # Verification and Simulation
│   └── tb.v            # Top-level testbench
└── hex/                # 6 instruction memory files for various aspects
    ├── test1.hex       # Arithmetic tests
    ├── test2.hex       # Data forwarding validation
    ├── test3.hex       # Load-use hazard and stall logic
    ├── test4.hex       # Branch evaluation and flushing
    ├── test5.hex       # Memory read/write consistency
    └── test6.hex       # Comprehensive integration test
